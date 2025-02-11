/**
 * @Description       : 
 * @Author            : cristianivan.ruiz@salesforce.com
 * @Code Coverage     : 
 * @last modified on  : 01-13-2025
 * @last modified by  : cristianivan.ruiz@salesforce.com
**/
public with sharing class DX_PanelSelectorRacks_ctr {
    
    /**
    * @description method to get wrapper structure for floors information
    * @author cristianivan.ruiz@salesforce.com | 12-11-2024 
    * @param buildingId 
    * @return List<DX_DCIM_DataAccess.wrapperResult> 
    **/
    @AuraEnabled(cacheable=true)
    public static List<DX_DCIM_DataAccess.wrapperResult> getFloors(String buildingId) {
        List<DX_DCIM_DataAccess.wrapperResult> lstwrapperResult = new List<DX_DCIM_DataAccess.wrapperResult>();
        List<DC_Floor__c> lstFloors = DX_DCIM_DataAccess.getFloors(buildingId);
        if(!lstFloors.isEmpty()){
            for(DC_Floor__c item : lstFloors){
                DX_DCIM_DataAccess.wrapperResult objwrapperResult = DX_DCIM_DataAccess.objWrapperResult(item.Id, item.Name);
                lstwrapperResult.add(objwrapperResult);
            }
        }
        return lstwrapperResult;
    }

    /**
    * @description method to get wrapper structure for data halls information
    * @author cristianivan.ruiz@salesforce.com | 12-11-2024 
    * @param floorId 
    * @return List<DX_DCIM_DataAccess.wrapperResult> 
    **/
    @AuraEnabled(cacheable=true)
    public static List<DX_DCIM_DataAccess.wrapperResult> getDataHalls(String floorId) {
        List<DX_DCIM_DataAccess.wrapperResult> lstwrapperResult = new List<DX_DCIM_DataAccess.wrapperResult>();
        List<DC_Data_Hall__c> lstDataHalls = DX_DCIM_DataAccess.getDataHalls(floorId);
        if(!lstDataHalls.isEmpty()){
            for(DC_Data_Hall__c item : lstDataHalls){
                DX_DCIM_DataAccess.wrapperResult objwrapperResult = DX_DCIM_DataAccess.objWrapperResult(item.Id, item.Name);
                lstwrapperResult.add(objwrapperResult);
            }
        }
        return lstwrapperResult;
    }
    /**
    * @description method to get wrapper structure for meet me rooms information
    * @author cristianivan.ruiz@salesforce.com | 12-11-2024 
    * @param dataHallId 
    * @return List<DX_DCIM_DataAccess.wrapperResult> 
    **/
    @AuraEnabled(cacheable=true)
    public static List<DX_DCIM_DataAccess.wrapperResult> getMeetMeRooms(String dataHallId) {
        List<DX_DCIM_DataAccess.wrapperResult> lstwrapperResult = new List<DX_DCIM_DataAccess.wrapperResult>();
        List<DC_Meet_Me_Room__c> lstMeetMeRooms = DX_DCIM_DataAccess.getMeetMeRooms(dataHallId);
        if(!lstMeetMeRooms.isEmpty()){
            for(DC_Meet_Me_Room__c item : lstMeetMeRooms){
                DX_DCIM_DataAccess.wrapperResult objwrapperResult = DX_DCIM_DataAccess.objWrapperResult(item.Id, item.Name);
                lstwrapperResult.add(objwrapperResult);
            }
        }
        return lstwrapperResult;
    }

    /**
    * @description method to get wrapper structure for racks information
    * @author cristianivan.ruiz@salesforce.com | 12-11-2024 
    * @param meetMeRoomId 
    * @return List<DX_DCIM_DataAccess.wrapperResult> 
    **/
    @AuraEnabled(cacheable=true)
    public static List<DX_DCIM_DataAccess.wrapperResult> getRacks(String meetMeRoomId) {
        List<DX_DCIM_DataAccess.wrapperResult> lstwrapperResult = new List<DX_DCIM_DataAccess.wrapperResult>();
        List<DC_Rack__c> lstRacks = DX_DCIM_DataAccess.getRacks(meetMeRoomId);
        if(!lstRacks.isEmpty()){
            for(DC_Rack__c item : lstRacks){
                DX_DCIM_DataAccess.wrapperResult objwrapperResult = DX_DCIM_DataAccess.objWrapperResult(item.Id, item.Name);
                lstwrapperResult.add(objwrapperResult);
            }
        }
        return lstwrapperResult;
    }
    
}