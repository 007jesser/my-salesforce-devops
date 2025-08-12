/**
 * @description Unit tests for `ProductController`.
 */
@isTest
private class TestProductController {
    private static final String PRODUCT_NAME1 = 'Sample Bike 1';
    private static final String PRODUCT_NAME2 = 'Sample Bike 2';

    @testSetup
    static void createProducts() {
        Product_Family__c family = new Product_Family__c(
            Name = 'TestFamily',
            Category__c = 'Mountain'
        );
        insert family;

        insert new List<Product__c>{
            new Product__c(
                Name = PRODUCT_NAME1,
                MSRP__c = 1000,
                Category__c = 'Mountain',
                Level__c = 'Beginner',
                Material__c = 'Carbon',
                Product_Family__c = family.Id
            ),
            new Product__c(
                Name = PRODUCT_NAME2,
                MSRP__c = 1200,
                Category__c = 'Mountain',
                Level__c = 'Racer',
                Material__c = 'Carbon',
                Product_Family__c = family.Id
            )
        };
    }

    @isTest
    static void testGetProductsWorks() {
        // Execute as a standard user for query security enforcement
        // Execute as a standard user for query security enforcement
        Profile stdProfile = [
            SELECT Id
            FROM Profile
            WHERE Name = 'Standard User'
            LIMIT 1
        ];
        User stdUser = new User(
            Alias = 'prdtst',
            Email = 'prd.tst@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'PrdTest',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles',
            ProfileId = stdProfile.Id,
            Username = 'prd.tst' + DateTime.now().getTime() + '@example.com'
        );
        insert stdUser;

        System.runAs(stdUser) {
            ProductController.Filters filters = new ProductController.Filters();
            filters.searchKey = 'Sample';
            filters.maxPrice = 2000;
            filters.categories = new List<String>{ 'Mountain' };
            filters.levels = new List<String>{ 'Beginner' };
            filters.materials = new List<String>{ 'Carbon' };

            PagedResult result = ProductController.getProducts(filters, 1);

            System.assertEquals(1, result.records.size());
            System.assertEquals(
                PRODUCT_NAME1,
                ((Product__c) result.records[0]).Name
            );
        }
    }

    @isTest
    static void testGetSimilarProductsWorks() {
        // Create a user context and execute runAs to satisfy PMD requirement
        Profile stdProfile = [
            SELECT Id
            FROM Profile
            WHERE Name = 'Standard User'
            LIMIT 1
        ];
        User stdUser2 = new User(
            Alias = 'prd2tst',
            Email = 'prd2.tst@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Prd2Test',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles',
            ProfileId = stdProfile.Id,
            Username = 'prd2.tst' + DateTime.now().getTime() + '@example.com'
        );
        insert stdUser2;
        // Execute inside runAs to satisfy PMD requirement
        System.runAs(stdUser2) {
            Product__c baseProduct = [
                SELECT Id, Name, Product_Family__c
                FROM Product__c
                WHERE Name = :PRODUCT_NAME1
            ];

            Product__c[] similarProducts = ProductController.getSimilarProducts(
                baseProduct.Id,
                baseProduct.Product_Family__c
            );

            System.assertEquals(1, similarProducts.size());
            System.assertEquals(PRODUCT_NAME2, similarProducts[0].Name);
        }
    }
}
