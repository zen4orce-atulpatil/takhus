/*Description : This class is used as a Domain class for SupplyChain Component. Purpose of this class is to perforn CRUD Operations.
Projects data
Created By : Mustafa
Created Date : November 2016*/
public with sharing class SupplyChainDomain {

    //Description:- Purpose of this method is to insert/update PM_Approved_Mfg_Plant__c records.
    public static boolean upsertManufacturingPlants(List<PM_Approved_Mfg_Plant__c> plantsList){
		boolean isSuccess = true;
    	Database.UpsertResult[] results = Database.upsert(plantsList,true);
    	for(Integer i=0;i<results.size();i++){
    		if(!results[i].isSuccess()){
    			isSuccess = false;	
    		}	
    	}
    	return isSuccess;
    }
    
    //Description:- Puepose of this method is to Insert/update PM_Approved_WH__c records.
    public static boolean upsertWarehousePlants(List<PM_Approved_WH__c> plantsList){
		boolean isSuccess = true;
    	Database.UpsertResult[] results = Database.upsert(plantsList,true);
    	for(Integer i=0;i<results.size();i++){
    		if(!results[i].isSuccess()){
    			isSuccess = false;	
    		}	
    	}
    	return isSuccess;
    }
    
    //Description : Purpose of this method is to delete Where_Used__c Records.
    public static boolean deleteManufacturingPlants(List<PM_Approved_Mfg_Plant__c> PlantsToDelete){
    	boolean isSuccess = true;
    	if(PlantsToDelete.size()>0){
			Database.DeleteResult[] results = Database.delete(PlantsToDelete,true);
	    	for(Integer i=0;i<results.size();i++){
	    		if(!results[i].isSuccess()){
	    			isSuccess = false;	
	    		}	
	    	}    	
    	}
    	return isSuccess;
    }
    
    //Description : Purpose of this method is to delete Where_Used__c Records.
    public static boolean deleteWarehousePlants(List<PM_Approved_WH__c> PlantsToDelete){
    	boolean isSuccess = true;
    	if(PlantsToDelete.size()>0){
			Database.DeleteResult[] results = Database.delete(PlantsToDelete,true);
	    	for(Integer i=0;i<results.size();i++){
	    		if(!results[i].isSuccess()){
	    			isSuccess = false;	
	    		}	
	    	}    	
    	}
    	return isSuccess;
    }
}