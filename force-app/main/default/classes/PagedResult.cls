/**
 * @description Simple DTO that holds pagination metadata and the resulting record collection.
 */
public with sharing class PagedResult {
    @AuraEnabled
    /** @description Number of records per page. */ public Integer pageSize {
        get;
        set;
    }
    @AuraEnabled
    /** @description Current 1-based page number. */ public Integer pageNumber {
        get;
        set;
    }
    @AuraEnabled
    /** @description Total number of matching records. */ public Integer totalItemCount {
        get;
        set;
    }
    @AuraEnabled
    /** @description Page of records returned by the query. */ public List<Object> records {
        get;
        set;
    }
}
