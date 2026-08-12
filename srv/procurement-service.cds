using { com.procureflow as db } from '../db/schema';

@path: '/procurement'
service ProcurementService {

    type ActionResult {
    message : String(500);
}

    @readonly
    entity Companies
        as projection on db.Companies;

    @readonly
    entity Plants
        as projection on db.Plants;

    @readonly
    entity Employees
        as projection on db.Employees;

    entity Suppliers
        as projection on db.Suppliers;

    @readonly
    entity MaterialGroups
        as projection on db.MaterialGroups;

    @readonly
    entity Materials
        as projection on db.Materials;

    entity PurchaseRequisitions
        as projection on db.PurchaseRequisitions;

    entity PurchaseRequisitionItems
        as projection on db.PurchaseRequisitionItems;
entity PurchaseOrders
    as projection on db.PurchaseOrders
    actions {

        @Core.OperationAvailable: {
            $edmJson: {
                $And: [
                    { $Ne: [ { $Path: 'status' }, 'APPROVED' ] },
                    { $Ne: [ { $Path: 'status' }, 'CANCELLED' ] },
                    { $Ne: [ { $Path: 'status' }, 'COMPLETED' ] },
                    { $Ne: [ { $Path: 'status' }, 'REJECTED' ] }
                ]
            }
        }
        action approve()
            returns ActionResult;

        @Core.OperationAvailable: {
            $edmJson: {
                $And: [
                    { $Ne: [ { $Path: 'status' }, 'REJECTED' ] },
                    { $Ne: [ { $Path: 'status' }, 'COMPLETED' ] },
                    { $Ne: [ { $Path: 'status' }, 'CANCELLED' ] },
                    { $Ne: [ { $Path: 'status' }, 'APPROVED' ] }
                ]
            }
        }
        action reject(reason : String(500))
            returns ActionResult;
    };

    entity PurchaseOrderItems
        as projection on db.PurchaseOrderItems;
}