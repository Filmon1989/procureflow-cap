namespace com.procureflow;

using {
    cuid,
    managed
} from '@sap/cds/common';

using {
    sap.common.Countries,
    sap.common.Currencies
} from '@sap/cds/common';


type SupplierStatus : String enum {
    Active   = 'ACTIVE';
    Blocked  = 'BLOCKED';
    Inactive = 'INACTIVE';
}

type RiskLevel : String enum {
    Low      = 'LOW';
    Medium   = 'MEDIUM';
    High     = 'HIGH';
    Critical = 'CRITICAL';
}

type ProcurementStatus : String enum {
    Draft     = 'DRAFT';
    Submitted = 'SUBMITTED';
    Approved  = 'APPROVED';
    Rejected  = 'REJECTED';
    Ordered   = 'ORDERED';
    Completed = 'COMPLETED';
    Cancelled = 'CANCELLED';
}


/* =========================================================
   ORGANIZATIONAL STRUCTURE
   ========================================================= */

entity Companies : cuid, managed {
    companyCode : String(4)   @title: 'Company Code';
    name        : String(100) @title: 'Company Name';

    country     : Association to Countries;
    currency    : Association to Currencies;

    active      : Boolean default true;
}


entity Plants : cuid, managed {
    plantCode   : String(4)   @title: 'Plant';
    name        : String(100) @title: 'Plant Name';

    company     : Association to Companies;
    country     : Association to Countries;

    city        : String(80);
    postalCode  : String(20);
    street      : String(120);

    purchasingOrganization : String(4);

    active      : Boolean default true;
}


/* =========================================================
   EMPLOYEES
   ========================================================= */

entity Employees : cuid, managed {
    employeeNumber : String(10);

    firstName      : String(60);
    lastName       : String(60);

    email          : String(120);
    department     : String(80);
    jobTitle       : String(100);

    plant          : Association to Plants;

    manager        : Association to Employees;

    active         : Boolean default true;
}


/* =========================================================
   SUPPLIERS
   ========================================================= */

entity Suppliers : cuid, managed {
    supplierNumber : String(10)  @title: 'Supplier Number';
    companyName    : String(150) @title: 'Supplier';

    country        : Association to Countries;

    city           : String(80);
    postalCode     : String(20);
    street         : String(120);

    email          : String(120);
    phone          : String(40);
    taxNumber      : String(40);

    currency       : Association to Currencies;

    paymentTerms   : String(10);
    incoterm       : String(10);

    category       : String(80);

    status         : SupplierStatus default #Active;
    riskLevel      : RiskLevel default #Low;

    qualityRating       : Decimal(3,2);
    deliveryRating      : Decimal(3,2);
    sustainabilityScore : Decimal(5,2);

    preferredSupplier : Boolean default false;
}


/* =========================================================
   MATERIAL MASTER
   ========================================================= */

entity MaterialGroups : cuid, managed {
    groupCode   : String(10);
    name        : String(100);
    description : String(500);
}


entity Materials : cuid, managed {
    materialNumber : String(18)  @title: 'Material Number';
    description    : String(150) @title: 'Material';

    materialGroup  : Association to MaterialGroups;

    baseUnit       : String(3);

    standardPrice  : Decimal(15,2);
    currency       : Association to Currencies;

    weight         : Decimal(13,3);
    weightUnit     : String(3);

    leadTimeDays   : Integer;

    minimumOrderQuantity : Decimal(13,3);

    active         : Boolean default true;
}


/* =========================================================
   PURCHASE REQUISITIONS
   ========================================================= */

entity PurchaseRequisitions : cuid, managed {
    requisitionNumber : String(12);

    requester : Association to Employees;
    plant     : Association to Plants;

    requestDate  : Date;
    requiredDate : Date;

    status       : ProcurementStatus default #Draft;

    priority     : String(10);

    justification : String(1000);

    estimatedValue : Decimal(15,2);
    currency       : Association to Currencies;

    items : Composition of many PurchaseRequisitionItems
            on items.requisition = $self;
}


entity PurchaseRequisitionItems : cuid, managed {
    requisition : Association to PurchaseRequisitions;

    itemNumber : Integer;

    material   : Association to Materials;

    quantity   : Decimal(13,3);
    unit       : String(3);

    estimatedUnitPrice : Decimal(15,2);
    currency           : Association to Currencies;

    requiredDate : Date;

    notes        : String(500);
}


/* =========================================================
   PURCHASE ORDERS
   ========================================================= */

entity PurchaseOrders : cuid, managed {
    purchaseOrderNumber : String(12);

    supplier : Association to Suppliers;
    plant    : Association to Plants;
    buyer    : Association to Employees;

    orderDate    : Date;
    deliveryDate : Date;

    status       : ProcurementStatus default #Draft;

    currency     : Association to Currencies;

    netAmount    : Decimal(15,2);
    taxAmount    : Decimal(15,2);
    totalAmount  : Decimal(15,2);

    paymentTerms : String(10);
    incoterm     : String(10);

    approvedBy   : Association to Employees;
    approvedAt   : Timestamp;

    notes        : String(1000);

    items : Composition of many PurchaseOrderItems
            on items.purchaseOrder = $self;
}


entity PurchaseOrderItems : cuid, managed {
    purchaseOrder : Association to PurchaseOrders;

    itemNumber : Integer;

    material   : Association to Materials;

    quantity   : Decimal(13,3);
    unit       : String(3);

    unitPrice  : Decimal(15,2);
    currency   : Association to Currencies;

    netAmount  : Decimal(15,2);

    deliveryDate : Date;

    requisitionItem : Association to PurchaseRequisitionItems;

    receivedQuantity : Decimal(13,3) default 0;

    notes : String(500);
}