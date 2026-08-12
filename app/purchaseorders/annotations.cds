using ProcurementService as service from '../../srv/procurement-service';
annotate service.PurchaseOrders with @(

    UI.HeaderInfo : {
        TypeName       : 'Purchase Order',
        TypeNamePlural : 'Purchase Orders',
        Title : {
            $Type : 'UI.DataField',
            Value : purchaseOrderNumber
        },
        Description : {
            $Type : 'UI.DataField',
            Value : status
        }
    },

    UI.SelectionFields : [
        purchaseOrderNumber,
        supplier_ID,
        plant_ID,
        status,
        orderDate,
        deliveryDate
    ],

    UI.LineItem : [

        {
            $Type : 'UI.DataField',
            Label : 'Purchase Order',
            Value : purchaseOrderNumber
        },

        {
            $Type : 'UI.DataField',
            Label : 'Supplier',
            Value : supplier.companyName
        },

        {
            $Type : 'UI.DataField',
            Label : 'Plant',
            Value : plant.name
        },

        {
            $Type : 'UI.DataField',
            Label : 'Order Date',
            Value : orderDate
        },

        {
            $Type : 'UI.DataField',
            Label : 'Delivery Date',
            Value : deliveryDate
        },

        {
            $Type : 'UI.DataField',
            Label : 'Status',
            Value : status
        },

        {
            $Type : 'UI.DataField',
            Label : 'Net Amount',
            Value : netAmount
        },

        {
            $Type : 'UI.DataField',
            Label : 'Total Amount',
            Value : totalAmount
        },

        {
            $Type : 'UI.DataField',
            Label : 'Currency',
            Value : currency_code
        }
    ],

            UI.Identification : [
        {
            $Type  : 'UI.DataFieldForAction',
            Label  : 'Approve',
            Action : 'ProcurementService.approve'
        },
        {
            $Type  : 'UI.DataFieldForAction',
            Label  : 'Reject',
            Action : 'ProcurementService.reject'
        }
    ],

    UI.FieldGroup #GeneralInformation : {
    $Type : 'UI.FieldGroupType',
    Data : [
        {
            $Type : 'UI.DataField',
            Label : 'Purchase Order',
            Value : purchaseOrderNumber
        },
        {
            $Type : 'UI.DataField',
            Label : 'Supplier',
            Value : supplier.companyName
        },
        {
            $Type : 'UI.DataField',
            Label : 'Plant',
            Value : plant.name
        },
        {
            $Type : 'UI.DataField',
            Label : 'Buyer Number',
            Value : buyer.employeeNumber
        },
        {
            $Type : 'UI.DataField',
            Label : 'Buyer First Name',
            Value : buyer.firstName
        },
        {
            $Type : 'UI.DataField',
            Label : 'Buyer Last Name',
            Value : buyer.lastName
        },
        {
            $Type : 'UI.DataField',
            Label : 'Order Date',
            Value : orderDate
        },
        {
            $Type : 'UI.DataField',
            Label : 'Delivery Date',
            Value : deliveryDate
        },
        {
            $Type : 'UI.DataField',
            Label : 'Status',
            Value : status
        }
    ]
},

        UI.FieldGroup #FinancialInformation : {
    $Type : 'UI.FieldGroupType',
    Data : [
        {
            $Type : 'UI.DataField',
            Label : 'Net Amount',
            Value : netAmount
        },
        {
            $Type : 'UI.DataField',
            Label : 'Tax Amount',
            Value : taxAmount
        },
        {
            $Type : 'UI.DataField',
            Label : 'Total Amount',
            Value : totalAmount
        },
        {
            $Type : 'UI.DataField',
            Label : 'Currency',
            Value : currency_code
        },
        {
            $Type : 'UI.DataField',
            Label : 'Payment Terms',
            Value : paymentTerms
        },
        {
            $Type : 'UI.DataField',
            Label : 'Incoterm',
            Value : incoterm
        },
        {
            $Type : 'UI.DataField',
            Label : 'Approved At',
            Value : approvedAt
        },
        {
            $Type : 'UI.DataField',
            Label : 'Notes',
            Value : notes
        }
    ]
},
    

    UI.Facets : [
    {
        $Type : 'UI.ReferenceFacet',
        ID     : 'GeneralInformation',
        Label  : 'General Information',
        Target : '@UI.FieldGroup#GeneralInformation'
    },
    {
        $Type : 'UI.ReferenceFacet',
        ID     : 'FinancialInformation',
        Label  : 'Financial Information',
        Target : '@UI.FieldGroup#FinancialInformation'
    },
    {
        $Type : 'UI.ReferenceFacet',
        ID     : 'PurchaseOrderItems',
        Label  : 'Purchase Order Items',
        Target : 'items/@UI.LineItem'
    }
]
);

annotate service.PurchaseOrders with {
    supplier @Common.ValueList : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'Suppliers',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : supplier_ID,
                ValueListProperty : 'ID',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'supplierNumber',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'companyName',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'country_code',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'city',
            },
        ],
    }
};

annotate service.PurchaseOrders with {
    plant @Common.ValueList : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'Plants',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : plant_ID,
                ValueListProperty : 'ID',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'plantCode',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'name',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'country_code',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'city',
            },
        ],
    }
};

annotate service.PurchaseOrders with {
    buyer @Common.ValueList : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'Employees',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : buyer_ID,
                ValueListProperty : 'ID',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'employeeNumber',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'firstName',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'lastName',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'email',
            },
        ],
    }
};

annotate service.PurchaseOrders with {
    approvedBy @Common.ValueList : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'Employees',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : approvedBy_ID,
                ValueListProperty : 'ID',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'employeeNumber',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'firstName',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'lastName',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'email',
            },
        ],
    }
};




annotate service.PurchaseOrderItems with @(

    UI.HeaderInfo : {
        TypeName       : 'Purchase Order Item',
        TypeNamePlural : 'Purchase Order Items',
        Title : {
            $Type : 'UI.DataField',
            Value : itemNumber
        },
        Description : {
            $Type : 'UI.DataField',
            Value : material.description
        }
    },

    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Label : 'Item',
            Value : itemNumber
        },
        {
            $Type : 'UI.DataField',
            Label : 'Material',
            Value : material.description
        },
        {
            $Type : 'UI.DataField',
            Label : 'Quantity',
            Value : quantity
        },
        {
            $Type : 'UI.DataField',
            Label : 'Unit',
            Value : unit
        },
        {
            $Type : 'UI.DataField',
            Label : 'Unit Price',
            Value : unitPrice
        },
        {
            $Type : 'UI.DataField',
            Label : 'Net Amount',
            Value : netAmount
        },
        {
            $Type : 'UI.DataField',
            Label : 'Currency',
            Value : currency_code
        },
        {
            $Type : 'UI.DataField',
            Label : 'Delivery Date',
            Value : deliveryDate
        },
        {
            $Type : 'UI.DataField',
            Label : 'Received Quantity',
            Value : receivedQuantity
        },

        {
            $Type  : 'UI.DataFieldForAction',
            Label  : 'Approve',
            Action : 'ProcurementService.approve'
        },
        {
            $Type  : 'UI.DataFieldForAction',
            Label  : 'Reject',
            Action : 'ProcurementService.reject'
        }
    ]
);

annotate service.PurchaseOrders with {
    netAmount   @Measures.ISOCurrency : currency_code;
    taxAmount   @Measures.ISOCurrency : currency_code;
    totalAmount @Measures.ISOCurrency : currency_code;
};

annotate service.PurchaseOrderItems with {
    unitPrice @Measures.ISOCurrency : currency_code;
    netAmount @Measures.ISOCurrency : currency_code;
};

annotate service.PurchaseOrders with @(
    Capabilities.InsertRestrictions : {
        Insertable : true
    },
    Capabilities.UpdateRestrictions : {
        Updatable : true
    }
);

// ============================================================
// FIELD EDITABILITY
// System-controlled Purchase Order fields
// ============================================================

annotate service.PurchaseOrders with {

    purchaseOrderNumber @readonly;
    
    netAmount   @readonly;
    taxAmount   @readonly;
    totalAmount @readonly;

    status      @readonly;
    approvedAt  @readonly;

};