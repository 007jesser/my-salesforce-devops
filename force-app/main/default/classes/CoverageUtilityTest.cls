/**
 * @description Utility test class that exercises small helper classes which are otherwise hard to cover,
 *              boosting org-wide code coverage.
 */
@IsTest
private class CoverageUtilityTest {
    /**
     * @testSetup Creates generic data used by the utility tests.
     */
    @testSetup
    static void setupData() {
        // Minimal product family & product so the controllers return real data.
        Product_Family__c fam = new Product_Family__c(Name = 'UtilityFam');
        insert fam;

        Product__c prod = new Product__c(
            Name = 'UtilityBike',
            MSRP__c = 1000,
            Category__c = 'Mountain',
            Level__c = 'Beginner',
            Material__c = 'Steel',
            Product_Family__c = fam.Id
        );
        insert prod;
    }

    /**
     * @description Covers `ProductRecordInfoController` and `HeroDetailsPositionCustomPicklist`.
     */
    @IsTest
    static void testUtilityControllers() {
        // Create a run-as context to satisfy PMD.
        Profile p = [
            SELECT Id
            FROM Profile
            WHERE Name = 'Standard User'
            LIMIT 1
        ];
        User u = new User(
            Alias = 'covusr',
            Email = 'covusr@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Coverage',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles',
            ProfileId = p.Id,
            Username = 'covusr' + DateTime.now().getTime() + '@example.com'
        );
        insert u;

        System.runAs(u) {
            // ---- ProductRecordInfoController ----
            List<String> info = ProductRecordInfoController.getRecordInfo(
                'UtilityBike'
            );
            System.assertEquals(2, info.size(), 'Expect Id and SObject type');
            System.assertEquals('Product__c', info[1]);

            // ---- HeroDetailsPositionCustomPicklist ----
            HeroDetailsPositionCustomPicklist pick = new HeroDetailsPositionCustomPicklist();
            VisualEditor.DataRow defRow = pick.getDefaultValue();
            System.assert(
                defRow != null,
                'Default pick-list value should not be null'
            );
            VisualEditor.DynamicPickListRows rows = pick.getValues();
            System.assert(
                rows != null && rows.size() >= 2,
                'Expect at least two pick-list rows'
            );

            // ---- PagedResult DTO ----
            PagedResult pr = new PagedResult();
            pr.pageSize = 1;
            pr.pageNumber = 1;
            pr.totalItemCount = 1;
            pr.records = new List<Object>{
                [SELECT Id FROM Product__c LIMIT 1]
            };
            System.assertEquals(1, pr.records.size());
        }
    }
}
