/**
 * @Description       : 
 * @Author            : cristianivan.ruiz@salesforce.com
 * @Code Coverage     : 
 * @last modified on  : 01-13-2025
 * @last modified by  : cristianivan.ruiz@salesforce.com
**/
public with sharing class DX_ConnectPorts_ctr {
    
    @AuraEnabled(cacheable=true)
    public static List<DX_DCIM_DataAccess.wrapperResult> getPorts(String panelId) {
        List<DX_DCIM_DataAccess.wrapperResult> lstwrapperResult = new List<DX_DCIM_DataAccess.wrapperResult>();
        List<DC_Port__c> lstPorts = DX_DCIM_DataAccess.getPorts(panelId);
        if(!lstPorts.isEmpty()){
            for(DC_Port__c item : lstPorts){
                DX_DCIM_DataAccess.wrapperResult objwrapperResult = DX_DCIM_DataAccess.objWrapperResult(item.Id, item.Name);
                lstwrapperResult.add(objwrapperResult);
            }
        }
        return lstwrapperResult;
    }
}