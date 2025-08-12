@IsTest
/**
 * @description Unit tests for `CommunitiesLandingController`.
 */
private with sharing class CommunitiesLandingControllerTest {
    /**
     * @description Verifies that `forwardToStartPage` returns an empty or null `PageReference` in test context.
     */
    public static void testForwardToStartPage() {
        // Create a dummy user to exercise run-as context
        Profile p = [
            SELECT Id
            FROM Profile
            WHERE Name = 'Standard User'
            LIMIT 1
        ];
        User testUser = new User(
            Alias = 'clctst',
            Email = 'clc.tst@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Test',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles',
            ProfileId = p.Id,
            Username = 'clc.tst' + DateTime.now().getTime() + '@example.com'
        );
        insert testUser;

        System.runAs(testUser) {
            // Instantiate a new controller with all parameters in the page
            CommunitiesLandingController controller = new CommunitiesLandingController();
            PageReference pageRef = controller.forwardToStartPage();
            //PageRef is either null or an empty object in test context
            if (pageRef != null) {
                String url = pageRef.getUrl();
                if (url != null) {
                    System.assert(
                        String.isEmpty(url),
                        'Expect empty URL or null in test context.'
                    );
                }
            }
        }
    }
}
