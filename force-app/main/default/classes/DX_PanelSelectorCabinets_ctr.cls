/**
 * @Description       : 
 * @Author            : cristianivan.ruiz@salesforce.com
 * @Code Coverage     : 
 * @last modified on  : 01-13-2025
 * @last modified by  : cristianivan.ruiz@salesforce.com
**/
public with sharing class DX_PanelSelectorCabinets_ctr {

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

    @AuraEnabled(cacheable=true)
    public static List<DX_DCIM_DataAccess.wrapperResult> getCages(String dataHallId) {
        List<DX_DCIM_DataAccess.wrapperResult> lstwrapperResult = new List<DX_DCIM_DataAccess.wrapperResult>();
        List<DC_Cage__c> lstCages = DX_DCIM_DataAccess.getCages(dataHallId);
        if(!lstCages.isEmpty()){
            for(DC_Cage__c item : lstCages){
                DX_DCIM_DataAccess.wrapperResult objwrapperResult = DX_DCIM_DataAccess.objWrapperResult(item.Id, item.Name);
                lstwrapperResult.add(objwrapperResult);
            }
        }
        
        return lstwrapperResult;
    }

    @AuraEnabled(cacheable=true)
    public static List<DX_DCIM_DataAccess.wrapperResult> getCabinets(String cageId) {
        List<DX_DCIM_DataAccess.wrapperResult> lstwrapperResult = new List<DX_DCIM_DataAccess.wrapperResult>();
        List<DC_Cabinet__c> lstCabinets = DX_DCIM_DataAccess.getCabinets(cageId);
        if(!lstCabinets.isEmpty()){
            for(DC_Cabinet__c item : lstCabinets){
                DX_DCIM_DataAccess.wrapperResult objwrapperResult = DX_DCIM_DataAccess.objWrapperResult(item.Id, item.Name);
                lstwrapperResult.add(objwrapperResult);
            }
        }
        
        return lstwrapperResult;
    }
    
}