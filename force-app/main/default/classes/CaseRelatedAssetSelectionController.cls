public with sharing class CaseRelatedAssetSelectionController {
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getRelatedAssets(String caseId) {
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
                SELECT Id, Name, SerialNumber, Status, Product2.Name, Asset_Location__c, Asset_Type__c 
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
    @AuraEnabled
    public static List<DC_Rack__c> getRacksForRackRow(String rackRowId){
        if (!Schema.sObjectType.DC_Rack__c.isAccessible()) {
            throw new AuraHandledException('You do not have access to DC_Rack__c');
        }
        List<DC_Rack__c> racks = new List<DC_Rack__c>();
        racks = [SELECT Id, Name, Number_of_Rack_Units__c, Rack_Type__c, Asset__c, Row_Number__c, Rack_Row__c, Account__c, Meet_Me_Room__c FROM DC_Rack__c WHERE Rack_Row__c = :rackRowId];
        return racks;
    }
    @AuraEnabled
    public static List<DC_Panel__c> getPanelsForRackRow(String rackRowId){
        if (!Schema.sObjectType.DC_Panel__c.isAccessible()) {
            throw new AuraHandledException('You do not have access to DC_Panel__c');
        }
        List<DC_Panel__c> panels = new List<DC_Panel__c>();
        panels = [SELECT Id, Name, Rack__c,
        Rack__r.Name, Rack__r.Number_of_Rack_Units__c, Rack__r.Rack_Type__c, Rack__r.Asset__c, Rack__r.Row_Number__c, Rack__r.Meet_Me_Room__c,
        Asset__c, Height_RU__c, Starting_Position_RU__c, Total_Number_of_Ports__c 
                                            FROM DC_Panel__c 
                                            WHERE Rack__r.Rack_Row__c = :rackRowId 
                                            ORDER BY Starting_Position_RU__c];
        return panels;
    }
    
    
}