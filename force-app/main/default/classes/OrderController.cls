/**
 * @description Aura-enabled service class for retrieving `Order_Item__c` records related to a given order.
 */
public with sharing class OrderController {
    /**
     * @description Returns the list of `Order_Item__c` records for the specified order.
     * @param orderId The Id of the `Order__c` record.
     * @return A list of related `Order_Item__c` records.
     */
    @AuraEnabled(Cacheable=true)
    public static Order_Item__c[] getOrderItems(Id orderId) {
        return [
            SELECT
                Id,
                Qty_S__c,
                Qty_M__c,
                Qty_L__c,
                Price__c,
                Product__r.Name,
                Product__r.MSRP__c,
                Product__r.Picture_URL__c
            FROM Order_Item__c
            WHERE Order__c = :orderId
            WITH USER_MODE
        ];
    }
}
