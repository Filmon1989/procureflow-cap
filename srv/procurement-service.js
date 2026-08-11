const cds = require('@sap/cds');

module.exports = cds.service.impl(async function () {

    const {
        PurchaseOrders,
        PurchaseOrderItems,
        Suppliers
    } = this.entities;

    /*
 * ============================================================
 * RECALCULATE PURCHASE ORDER TOTALS
 * ============================================================
 *
 * Calculates the Purchase Order header values from its items.
 */
async function recalculatePurchaseOrderTotals(purchaseOrderID) {

    const items = await SELECT
        .from(PurchaseOrderItems)
        .columns('netAmount')
        .where({
            purchaseOrder_ID: purchaseOrderID
        });


    /*
     * Sum all PO item net amounts.
     */
    const netAmount = items.reduce(
        (sum, item) => sum + Number(item.netAmount || 0),
        0
    );


    /*
     * For this portfolio project we initially use 19% tax.
     *
     * Later we can make tax determination dependent on
     * plant/country/business rules.
     */
    const taxAmount = netAmount * 0.19;

    const totalAmount = netAmount + taxAmount;


    /*
     * Store calculated amounts on the PO header.
     */
    await UPDATE(PurchaseOrders)
        .set({
            netAmount: Number(netAmount.toFixed(2)),
            taxAmount: Number(taxAmount.toFixed(2)),
            totalAmount: Number(totalAmount.toFixed(2))
        })
        .where({
            ID: purchaseOrderID
        });
}

    /*
     * ============================================================
     * PURCHASE ORDER VALIDATION
     * ============================================================
     *
     * Runs BEFORE CAP creates or updates a Purchase Order.
     *
     * Business rules:
     * 1. Delivery date cannot be before order date.
     * 2. Supplier must exist.
     * 3. Blocked suppliers cannot receive new Purchase Orders.
     * 4. Inactive suppliers cannot receive new Purchase Orders.
     */
    this.before(['CREATE', 'UPDATE'], PurchaseOrders, async (req) => {

        const {
            supplier_ID,
            orderDate,
            deliveryDate
        } = req.data;


        /*
         * Validate delivery date.
         */
        if (
            orderDate &&
            deliveryDate &&
            deliveryDate < orderDate
        ) {
            return req.reject(
                400,
                'Delivery date cannot be earlier than order date.'
            );
        }


        /*
         * Validate supplier.
         *
         * We only perform this check when supplier_ID
         * is included in the incoming request.
         */
        if (supplier_ID) {

            const supplier = await SELECT.one
                .from(Suppliers)
                .where({ ID: supplier_ID });


            if (!supplier) {
                return req.reject(
                    404,
                    'Supplier does not exist.'
                );
            }


            if (supplier.status === 'BLOCKED') {
                return req.reject(
                    400,
                    'Purchase orders cannot be created for blocked suppliers.'
                );
            }


            if (supplier.status === 'INACTIVE') {
                return req.reject(
                    400,
                    'Purchase orders cannot be created for inactive suppliers.'
                );
            }
        }

    });

    /*
 * ============================================================
 * PURCHASE ORDER ITEM VALIDATION
 * ============================================================
 *
 * Business rules:
 * 1. Quantity must be greater than zero.
 * 2. Unit price must be greater than zero.
 * 3. Net amount is calculated automatically.
 */
    this.before(
        ['CREATE', 'UPDATE'],
        PurchaseOrderItems,
        async (req) => {

            const {
                quantity,
                unitPrice
            } = req.data;


            /*
            * Validate quantity.
            */
            if (quantity !== undefined && quantity <= 0) {
                return req.reject(
                    400,
                    'Quantity must be greater than zero.'
                );
            }


            /*
            * Validate unit price.
            */
            if (unitPrice !== undefined && unitPrice <= 0) {
                return req.reject(
                    400,
                    'Unit price must be greater than zero.'
                );
            }


            /*
            * Automatically calculate net amount.
            */
            if (
                quantity !== undefined &&
                unitPrice !== undefined
            ) {
                req.data.netAmount =
                    Number(quantity) * Number(unitPrice);
            }

        }
    );


    /*
 * ============================================================
 * RECALCULATE PO AFTER ITEM CREATION
 * ============================================================
 */
    this.after(
        'CREATE',
        PurchaseOrderItems,
        async (createdItem) => {

            if (createdItem.purchaseOrder_ID) {
                await recalculatePurchaseOrderTotals(
                    createdItem.purchaseOrder_ID
                );
            }

        }
    );

    /*
 * ============================================================
 * RECALCULATE PO AFTER ITEM UPDATE
 * ============================================================
 */
    this.after(
        'UPDATE',
        PurchaseOrderItems,
        async (_, req) => {

            const item = await SELECT.one
                .from(req.subject);

            if (
                item &&
                item.purchaseOrder_ID
            ) {
                await recalculatePurchaseOrderTotals(
                    item.purchaseOrder_ID
                );
            }

        }
    );

    /*
     * ============================================================
     * APPROVE PURCHASE ORDER
     * ============================================================
     *
     * Bound action:
     *
     * POST /PurchaseOrders(<ID>)/approve
     *
     * req.subject represents the specific Purchase Order
     * on which the action was called.
     */
    this.on('approve', PurchaseOrders, async (req) => {

        /*
         * Read the Purchase Order addressed by the bound action.
         */
        const purchaseOrder = await SELECT.one
            .from(req.subject);


        /*
         * Make sure the Purchase Order exists.
         */
        if (!purchaseOrder) {
            return req.reject(
                404,
                'Purchase order not found.'
            );
        }


        /*
         * Prevent duplicate approval.
         */
        if (purchaseOrder.status === 'APPROVED') {
            return req.reject(
                400,
                'Purchase order is already approved.'
            );
        }


        /*
         * Cancelled Purchase Orders cannot be approved.
         */
        if (purchaseOrder.status === 'CANCELLED') {
            return req.reject(
                400,
                'Cancelled purchase orders cannot be approved.'
            );
        }


        /*
         * Update the Purchase Order.
         */
        await UPDATE(req.subject)
            .set({
                status: 'APPROVED',
                approvedAt: new Date().toISOString()
            });


        /*
         * Return a response to the API consumer.
         */
        return {
            message:
                `Purchase order ${purchaseOrder.purchaseOrderNumber} approved successfully.`
        };

    });


    /*
     * ============================================================
     * REJECT PURCHASE ORDER
     * ============================================================
     *
     * Bound action:
     *
     * POST /PurchaseOrders(<ID>)/reject
     *
     * The caller can provide:
     *
     * {
     *   "reason": "Reason for rejection"
     * }
     */
    this.on('reject', PurchaseOrders, async (req) => {

        /*
         * Get the action parameter from the request body.
         */
        const { reason } = req.data;


        /*
         * Read the Purchase Order addressed by the action.
         */
        const purchaseOrder = await SELECT.one
            .from(req.subject);


        /*
         * Make sure the Purchase Order exists.
         */
        if (!purchaseOrder) {
            return req.reject(
                404,
                'Purchase order not found.'
            );
        }


        /*
         * Completed Purchase Orders should not be rejected.
         */
        if (purchaseOrder.status === 'COMPLETED') {
            return req.reject(
                400,
                'Completed purchase orders cannot be rejected.'
            );
        }


        /*
         * Update status and store the rejection reason.
         *
         * If no reason was supplied, keep the existing notes.
         */
        await UPDATE(req.subject)
            .set({
                status: 'REJECTED',
                notes: reason || purchaseOrder.notes
            });


        /*
         * Return confirmation.
         */
        return {
            message:
                `Purchase order ${purchaseOrder.purchaseOrderNumber} rejected successfully.`
        };

    });

});