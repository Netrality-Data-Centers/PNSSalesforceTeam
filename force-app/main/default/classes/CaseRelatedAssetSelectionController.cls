public with sharing class CaseRelatedAssetSelectionController {
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getRelatedAssets(Id caseId) {
        // Get Case and related Quote
        Case currentCase = [
            SELECT Id, DX_Service_Order__c, Subject FROM Case WHERE Id = :caseId
        ];
        System.debug('got case:' + currentCase);
        // Get Assets related to the Quote
        List<Asset> assets = new List<Asset>();
        if (currentCase.DX_Service_Order__c != null) {
            System.debug('currentCase.DX_Related_Service_Order__c != null');
            
            assets = [
                SELECT Id, Name, SerialNumber, Status, Product2.Name, Asset_Location__c 
                FROM Asset 
                WHERE Service_Order__c = :currentCase.DX_Service_Order__c
            ];
            System.debug('got Assets, the length was:' + assets.size() );
        } else{
            System.debug('currentCase.DX_Service_Order__c == null');
        }
        
        return new Map<String, Object>{
            'assets' => assets,
            'caseName' => currentCase.Subject
        };
    }
}