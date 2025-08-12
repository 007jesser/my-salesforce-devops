/**
 * @description Controller that determines and redirects the user to the correct community start page.
 */
public with sharing class CommunitiesLandingController {
    /**
     * @description Returns the community landing `PageReference` for the running user.
     */
    public PageReference forwardToStartPage() {
        return Network.communitiesLanding();
    }
}
