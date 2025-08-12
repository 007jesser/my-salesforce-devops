/**
 * @description Unit tests for `OrderController`.
 */
@isTest
private class TestOrderController {
    @testSetup
    static void setup() {
        Account acc = new Account(Name = 'Sample Account');
        insert acc;

        Order__c order = new Order__c(Account__c = acc.Id);
        insert order;

        Product__c p = new Product__c(Name = 'Sample Product');
        insert p;

        Order_Item__c orderItem = new Order_Item__c(
            Order__c = order.Id,
            Product__c = p.Id
        );
        insert orderItem;
    }

    @isTest
    static void testGetOrderItems() {
        // Run inside user context to mimic portal user permissions
        Profile p = [
            SELECT Id
            FROM Profile
            WHERE Name = 'Standard User'
            LIMIT 1
        ];
        User contextUser = new User(
            Alias = 'ordtst',
            Email = 'ord.tst@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'OrderTest',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles',
            ProfileId = p.Id,
            Username = 'ord.tst' + DateTime.now().getTime() + '@example.com'
        );
        insert contextUser;

        System.runAs(contextUser) {
            {
                Order__c testOrder = [SELECT Id FROM Order__c];
                List<Order_Item__c> orderItems = OrderController.getOrderItems(
                    testOrder.Id
                );
                System.assertEquals(1, orderItems.size());
            }
        }
    }
}
