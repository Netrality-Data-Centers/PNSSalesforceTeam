/**
 * @Description       : 
 * @Author            : cristianivan.ruiz@salesforce.com
 * @Code Coverage     : 
 * @last modified on  : 01-13-2025
 * @last modified by  : cristianivan.ruiz@salesforce.com
**/
public with sharing class DX_PanelSelectorFloorPOE_ctr {
    
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
    public static List<DX_DCIM_DataAccess.wrapperResult> getPOES(String floorId) {
        List<DX_DCIM_DataAccess.wrapperResult> lstwrapperResult = new List<DX_DCIM_DataAccess.wrapperResult>();
        List<DC_POE__c> lstPOES = DX_DCIM_DataAccess.getPOES(floorId);
        if(!lstPOES.isEmpty()){
            for(DC_POE__c item : lstPOES){
                DX_DCIM_DataAccess.wrapperResult objwrapperResult = DX_DCIM_DataAccess.objWrapperResult(item.Id, item.Name);
                lstwrapperResult.add(objwrapperResult);
            }
        }
        
        return lstwrapperResult;
    }
    
}