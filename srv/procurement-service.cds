using { com.procureflow as db } from '../db/schema';

@path: '/procurement'
service ProcurementService {

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
        as projection on db.PurchaseOrders;

    entity PurchaseOrderItems
        as projection on db.PurchaseOrderItems;
}