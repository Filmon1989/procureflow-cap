sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"com/procureflow/purchaseorders/test/integration/pages/PurchaseOrdersList.gen",
	"com/procureflow/purchaseorders/test/integration/pages/PurchaseOrdersObjectPage.gen",
	"com/procureflow/purchaseorders/test/integration/pages/PurchaseOrderItemsObjectPage.gen"
], function (JourneyRunner, PurchaseOrdersListGenerated, PurchaseOrdersObjectPageGenerated, PurchaseOrderItemsObjectPageGenerated) {
    'use strict';

    const runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('com/procureflow/purchaseorders') + '/test/flp.html#app-preview',
        pages: {
			onThePurchaseOrdersListGenerated: PurchaseOrdersListGenerated,
			onThePurchaseOrdersObjectPageGenerated: PurchaseOrdersObjectPageGenerated,
			onThePurchaseOrderItemsObjectPageGenerated: PurchaseOrderItemsObjectPageGenerated
        },
        async: true
    });

    return runner;
});

