/**
 * @description Utility controller that returns record Id and sObject type for a given product or family name.
 */
public with sharing class ProductRecordInfoController {
    /**
     * @description Determines whether the name refers to a `Product__c` or `Product_Family__c` record and returns the Id and type.
     * @param productOrFamilyName Name of the product or family.
     * @return List with two elements: record Id and object API name, or null if not found.
     */
    @AuraEnabled(cacheable=true)
    public static List<String> getRecordInfo(String productOrFamilyName) {
        List<String> recordInfo = new List<String>();

        List<Product__c> cProductList = [
            SELECT ID
            FROM Product__c
            WHERE NAME = :productOrFamilyName
            WITH USER_MODE
        ];
        if (cProductList.size() > 0) {
            recordInfo.add(cProductList[0].ID);
            recordInfo.add('Product__c');
            return recordInfo;
        }

        List<Product_Family__c> cProductFamilyList = [
            SELECT ID
            FROM Product_Family__c
            WHERE NAME = :productOrFamilyName
            WITH USER_MODE
        ];
        if (cProductFamilyList.size() > 0) {
            recordInfo.add(cProductFamilyList[0].ID);
            recordInfo.add('Product_Family__c');
            return recordInfo;
        }
        return null;
    }
}
