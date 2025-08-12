/**
 * @description Simple DTO that holds pagination metadata and the resulting record collection.
 */
public with sharing class PagedResult {
    /** @description Number of records per page. */
    @AuraEnabled
    public Integer pageSize { get; set; }

    /** @description Current 1-based page number. */
    @AuraEnabled
    public Integer pageNumber { get; set; }

    /** @description Total number of matching records across all pages. */
    @AuraEnabled
    public Integer totalItemCount { get; set; }

    /** @description Page of records returned by the query. */
    @AuraEnabled
    public Object[] records { get; set; }
}
