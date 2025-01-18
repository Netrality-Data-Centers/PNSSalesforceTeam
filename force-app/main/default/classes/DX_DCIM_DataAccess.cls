/**
* @name DX_DCIM_DataAccess
* @description This class is a Data Accessor class, responsible for encapsulating and providing access to the data of the 
* Data_Hall__c, DC_POE_Allocation__c, DC_Tenant_Suite__c objects in the Salesforce database.
* It provides methods for querying and retrieving data related to these objects.
* The class respects Salesforce security and sharing settings, ensuring that only authorized users can access data.
*/
public with sharing class DX_DCIM_DataAccess {
    /**
    * @name getDataHallsByBuilding
    * @description This method retrieves data halls by building.
    * @param aBuildingId: The Id of the building for which to retrieve data halls.
    * @return List<Data_Hall__c>: A list of Data_Hall__c records associated with the specified building.
    */
    public List<DC_Data_Hall__c> getDataHallsByBuilding(Id aBuildingId) { // NOPMD
        return [SELECT Id, Name FROM DC_Data_Hall__c where DC_Floor__r.Building__c=:aBuildingId WITH SECURITY_ENFORCED ORDER BY Name ASC];
    }

     /**
    * @name getPoeAllocationsByBuilding
    * @description This method retrieves Power of End (PoE) allocations by building.
    * @param aBuildingId: The Id of the building for which to retrieve PoE allocations.
    * @return List<POE_Allocation__c>: A list of POE_Allocation__c records associated with the specified building.
    */
    public List<DC_POE_Allocation__c> getPoeAllocationsByBuilding(Id aBuildingId) { // NOPMD
        return [SELECT Id, Name FROM DC_POE_Allocation__c where Floor__r.Building__c=:aBuildingId WITH SECURITY_ENFORCED ORDER BY Name ASC];
    }

    /**
    * @name getTenantSuitesByBuilding
    * @description This method retrieves tenant suites by building.
    * @param aBuildingId: The Id of the building for which to retrieve tenant suites.
    * @return List<DC_Tenant_Suite__c>: A list of DC_Tenant_Suite__c records associated with the specified building.
    */
    public List<DC_Tenant_Suite__c> getTenantSuitesByBuilding(Id aBuildingId) { // NOPMD
        return [SELECT Id, Name FROM DC_Tenant_Suite__c where Floor__r.Building__c=:aBuildingId WITH SECURITY_ENFORCED ORDER BY Name ASC];
    }

    /**
    * @name getCabinetsByBuildingAndAccount
    * @description This method retrieves cabinets filtered by building and account.
    * @param aBuildingId: The Id of the building for which to retrieve cabinets.
    * @param aAccountId: The Id of the account for which to retrieve cabinets.
    * @return List<DC_Cabinet__c>: A list of DC_Cabinet__c records associated with the specified building and account.
    */
    public List<DC_Cabinet__c> getCabinetsByBuildingAndAccount(Id aBuildingId, Id aAccountId) { // NOPMD
        return [SELECT Id, Name FROM DC_Cabinet__c WHERE Cage__r.Data_Hall__r.DC_Floor__r.Building__c=:aBuildingId AND Asset__r.AccountId=:aAccountId WITH SECURITY_ENFORCED ORDER BY Name ASC];
    }
    
    /**
    * @description method to get floors information by building id
    * @author cristianivan.ruiz@salesforce.com | 12-11-2024 
    * @param buildingId 
    * @return List<DC_Floor__c> 
    **/
    public static List<DC_Floor__c> getFloors(String buildingId) {
        List<DC_Floor__c> lstFloors = [SELECT Id, Name FROM DC_Floor__c WHERE Building__c = :buildingId WITH SECURITY_ENFORCED ORDER BY Name ASC];
        return lstFloors;
    }

    /**
    * @description method to get data halls information by floor id
    * @author cristianivan.ruiz@salesforce.com | 12-11-2024 
    * @param floorId 
    * @return List<DC_Data_Hall__c> 
    **/
    public static List<DC_Data_Hall__c> getDataHalls(String floorId) {
        List<DC_Data_Hall__c> lstDataHalls = [SELECT Id, Name FROM DC_Data_Hall__c WHERE DC_Floor__c = :floorId WITH SECURITY_ENFORCED ORDER BY Name ASC];
        return lstDataHalls;
    }
    
    /**
    * @description method to get meet me rooms information by data hall id
    * @author cristianivan.ruiz@salesforce.com | 12-11-2024 
    * @param dataHallId 
    * @return List<DC_Meet_Me_Room__c> 
    **/
    public static List<DC_Meet_Me_Room__c> getMeetMeRooms(String dataHallId) {
        List<DC_Meet_Me_Room__c> lstMeetMeRooms = [SELECT Id, Name FROM DC_Meet_Me_Room__c WHERE Data_Hall__c = :dataHallId WITH SECURITY_ENFORCED ORDER BY Name ASC];
        return lstMeetMeRooms;
    }

    /**
    * @description method to get racks information by meet me room id
    * @author cristianivan.ruiz@salesforce.com | 12-11-2024 
    * @param meetMeRoomId 
    * @return List<DC_Rack__c> 
    **/
    public static List<DC_Rack__c> getRacks(String meetMeRoomId) {
        List<DC_Rack__c> lstRacks = [SELECT Id, Name FROM DC_Rack__c WHERE  Meet_Me_Room__c = :meetMeRoomId WITH SECURITY_ENFORCED ORDER BY Name ASC];
        return lstRacks;
    }

    /**
    * @description method to get cages information by data hall id
    * @author cristianivan.ruiz@salesforce.com | 12-11-2024 
    * @param dataHallId 
    * @return List<DC_Cage__c> 
    **/
    public static List<DC_Cage__c> getCages(String dataHallId) {
        List<DC_Cage__c> lstCages = [SELECT Id, Name FROM DC_Cage__c WHERE Data_Hall__c = :dataHallId WITH SECURITY_ENFORCED ORDER BY Name ASC];
        return lstCages;
    }

    /**
    * @description method to get cabinets information by cage id
    * @author cristianivan.ruiz@salesforce.com | 12-11-2024 
    * @param cageId 
    * @return List<DC_Cabinet__c> 
    **/
    public static List<DC_Cabinet__c> getCabinets(String cageId) {
        List<DC_Cabinet__c> lstCabinets = [SELECT Id, Name FROM DC_Cabinet__c WHERE Cage__c = :cageId WITH SECURITY_ENFORCED ORDER BY Name ASC];
        return lstCabinets;
    }
    
    /**
    * @description method to get POES information by floor id
    * @author cristianivan.ruiz@salesforce.com | 12-12-2024 
    * @param floorId 
    * @return List<DC_POE__c> 
    **/
    public static List<DC_POE__c> getPOES(String floorId) {
        List<DC_POE__c> lstCabinets = [SELECT Id, Name FROM DC_POE__c WHERE Floor__c = :floorId WITH SECURITY_ENFORCED ORDER BY Name ASC];
        return lstCabinets;
    }
    
    /**
    * @description method to get Meet Me Rooms information by buildingId id
    * @author cristianivan.ruiz@salesforce.com | 01-09-2025 
    * @param buildingId 
    * @return List<DC_Meet_Me_Room__c> 
    **/
    public static List<DC_Meet_Me_Room__c> getMeetMeRoom(String buildingId) {
        List<DC_Meet_Me_Room__c> lstMeetMeRooms = [SELECT Id, Name FROM DC_Meet_Me_Room__c WHERE Data_Hall__r.DC_Floor__r.Building__c = :buildingId WITH SECURITY_ENFORCED ORDER BY Name ASC];
        return lstMeetMeRooms;
    }
    
    /**
    * @description method to get Panels information by Meet Me Room id and Account Id
    * @author cristianivan.ruiz@salesforce.com | 01-09-2025 
    * @param meetMeRoomId 
    * @param accountId 
    * @return List<DC_Panel__c> 
    **/
    public static List<DC_Panel__c> getPanel(String meetMeRoomId, String accountId) {
        List<DC_Panel__c> lstPanels = [SELECT Id, Name FROM DC_Panel__c WHERE Rack__r.Meet_Me_Room__c = :meetMeRoomId AND Asset__r.AccountId = :accountId WITH SECURITY_ENFORCED ORDER BY Name ASC];
        return lstPanels;
    }

    /**
    * @description method to get Ports information by Panel Id
    * @author cristianivan.ruiz@salesforce.com | 01-09-2025 
    * @param panelId 
    * @return List<DC_Port__c> 
    **/
    public static List<DC_Port__c> getPorts(String panelId) {
        List<DC_Port__c> lstPorts = [SELECT Id, Name FROM DC_Port__c WHERE Panel__c = :panelId WITH SECURITY_ENFORCED ORDER BY Name ASC];
        return lstPorts;
    }

    /**
    * @description method to get wrapper structure
    * @author cristianivan.ruiz@salesforce.com | 12-11-2024 
    * @param strId 
    * @param strName 
    * @return wrapperResult 
    **/
    public static wrapperResult objWrapperResult(String strId, String strName) {
        wrapperResult objwrapperResult = new wrapperResult();
        objwrapperResult.value = strId;
        objwrapperResult.label = strName;
        return objwrapperResult;
    }
    
    public class wrapperResult{
        @AuraEnabled 
        Public String value { get; set; }
        @AuraEnabled 
        Public String label { get; set; }
    }
}