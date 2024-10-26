/**
 * @Description       : 
 * @Author            : cristianivan.ruiz@salesforce.com
 * @Code Coverage     : 
 * @last modified on  : 10-23-2024
 * @last modified by  : cristianivan.ruiz@salesforce.com
**/
public with sharing class DX_SubmitServiceRequest_cls {
     
    // Method to get Record Types for a specific User Permission
	@AuraEnabled(cacheable=true)
    public static List<wrapperResult> getRecordTypesForUserPermission() {
        List<wrapperResult> lstwrapperResult = new List<wrapperResult>();
        List<SelectOption> recordTypes = new List<SelectOption>();
        for(RecordTypeInfo info: Case.SObjectType.getDescribe().getRecordTypeInfos()) {
            if(info.isAvailable()) {
                recordTypes.add(new SelectOption(info.getRecordTypeId(), info.getName()));
            }
        }
        
        for( SelectOption selopt: recordTypes ) {
            wrapperResult objwrapperResult = new wrapperResult();
            System.debug( selopt.getLabel() + ',' + selopt.getValue() );
            objwrapperResult.value = selopt.getValue();
            objwrapperResult.label = selopt.getLabel();
            lstwrapperResult.add(objwrapperResult);
        }
        return lstwrapperResult;
    }
    
    @AuraEnabled
    public static void upsertCase(CaseWrapper caseWrapper) {
        // Validate input (optional)
        if (caseWrapper == null || String.isBlank(caseWrapper.caseId)) {
            throw new AuraHandledException('Invalid case data.');
        }

        // Create or update the Case object
        Case caseToUpsert = new Case();
        caseToUpsert.Id = caseWrapper.caseId;
        caseToUpsert.Subject = caseWrapper.subject;
        caseToUpsert.Description = caseWrapper.description;
        caseToUpsert.Status = caseWrapper.status;

        // Upsert the Case record
        upsert caseToUpsert;
    }

    public class CaseWrapper {
        @AuraEnabled public String caseId { get; set; }
        @AuraEnabled public String subject { get; set; }
        @AuraEnabled public String description { get; set; }
        @AuraEnabled public String status { get; set; }
    }

    public class wrapperResult{
        @AuraEnabled 
        Public String value { get; set; }
        @AuraEnabled 
        Public String label { get; set; }
    }

    //status picklist
    @AuraEnabled(cacheable=true)
    public static List<String> getCaseStatusPicklistValues() {
        List<String> statusValues = new List<String>();
        
        // Describe the Case object
        Schema.DescribeSObjectResult caseDescribe = Schema.SObjectType.Case;
        Schema.DescribeFieldResult statusFieldDescribe = caseDescribe.fields.getMap().get('Status').getDescribe();
        
        // Get the picklist values
        for (Schema.PicklistEntry entry : statusFieldDescribe.getPicklistValues()) {
            statusValues.add(entry.getValue());
        }
        
        return statusValues;
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getCaseTypePicklistValues() {
        List<String> typesValues = new List<String>();
        
        // Describe the Case object
        Schema.DescribeSObjectResult caseDescribe = Schema.SObjectType.Case;
        Schema.DescribeFieldResult statusFieldDescribe = caseDescribe.fields.getMap().get('Type').getDescribe();
        
        // Get the picklist values
        for (Schema.PicklistEntry entry : statusFieldDescribe.getPicklistValues()) {
            typesValues.add(entry.getValue());
        }
        
        return typesValues;
    }



    //Get accounts releted
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountsByCaseId(Id caseId) {
        if (caseId == null) {
            return new List<Account>();
        }

        // Query to fetch accounts related to the case
        List<Case> cases = [SELECT Id, AccountId FROM Case WHERE Id = :caseId LIMIT 1];
        
        if (cases.isEmpty() || cases[0].AccountId == null) {
            return new List<Account>();
        }

        return [SELECT Id, Name FROM Account WHERE Id = :cases[0].AccountId];
    }
}