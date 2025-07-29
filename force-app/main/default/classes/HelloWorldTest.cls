/**
 * @description
 *   Verifies that HelloWorld.sayHello() returns the expected greeting
 *   when run as a non‑admin user.
 */
@isTest
private class HelloWorldTest {
    @isTest static void testSayHello() {
        // Create a test user
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User' LIMIT 1];
        User u = new User(
            Username          = 'runasuser@example.com',
            LastName          = 'Test',
            Email             = 'runasuser@example.com',
            Alias             = 'testuser',
            TimeZoneSidKey    = 'America/Los_Angeles',
            LocaleSidKey      = 'en_US',
            EmailEncodingKey  = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            ProfileId         = p.Id
        );
        insert u;

        // Use System.runAs to satisfy PMD’s test‑coverage rule
        System.runAs(u) {
            String result = HelloWorld.sayHello();
            System.assertEquals('Hello, Salesforce!', result);
        }
    }
}
