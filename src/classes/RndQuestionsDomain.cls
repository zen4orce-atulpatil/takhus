/*Description : This class is used as a Domain class for RnsQuestions Component. Purpose of this class is to perforn CRUD Operations.
Projects data
Created By : Mustafa
Created Date : November 2016*/
public class RndQuestionsDomain {
	//Description : Purpose of this method is to upsert BOM..
    public static boolean upsertBom(List<Where_Used__c> lstBomToUpsert){
		boolean isSuccess = true;
		Database.UpsertResult[] results = Database.upsert(lstBomToUpsert,true);
    	for(Integer i=0;i<results.size();i++){
    		if(!results[i].isSuccess()){
    			isSuccess = false;
    		}	
    	}		
		return isSuccess;
    }
    
    //Description : Purpose of this method is to upsert PM_Composition__c Records.
    public static boolean upsertPmComp(List<PM_Composition__c> lstPmCompToUpsert){
		boolean isSuccess = true;
    	Database.UpsertResult[] results = Database.upsert(lstPmCompToUpsert,true);
    	for(Integer i=0;i<results.size();i++){
    		if(!results[i].isSuccess()){
    			isSuccess = false;	
    		}	
    	}
    	return isSuccess;
    }
    
    //Description : Purpose of this method is to upsert PM_Mix_Instruction__c Record.
    public static boolean upsertPmMixInstruction(PM_Mix_Instruction__c pmMixInstruction){
    	Database.UpsertResult result = Database.upsert(pmMixInstruction);
    	boolean isSuccess = result.isSuccess();
    	return isSuccess;
    }
    
    //Description : Purpose of this method is to upsert PM_Physical_Properties__c Records.
    public static boolean upsertPmPhysicalPrperties(List<PM_Physical_Properties__c> lstPmPhyProperties){
		boolean isSuccess = true;
		Database.UpsertResult[] results = Database.upsert(lstPmPhyProperties,true);
    	for(Integer i=0;i<results.size();i++){
    		if(!results[i].isSuccess()){
    			isSuccess = false;	
    		}	
    	}		
    	return isSuccess;
    }
    
    //Description : Purpose of this method is to upsert PM_QA_Spec__c Records.
    public static boolean upertPmQaSpec(List<PM_QA_Spec__c> lstPmQaSpec){
		boolean isSuccess = true;
		Database.UpsertResult[] results = Database.upsert(lstPmQaSpec,true);
    	for(Integer i=0;i<results.size();i++){
    		if(!results[i].isSuccess()){
    			isSuccess = false;	
    		}	
    	}
    	return isSuccess;
    }
    
    //Description : Purpose of this method is to delete Where_Used__c Records.
    public static boolean deleteBoms(List<Where_Used__c> lstBomToDelete){
    	boolean isSuccess = true;
    	if(lstBomToDelete.size()>0){
			Database.DeleteResult[] results = Database.delete(lstBomToDelete,true);
	    	for(Integer i=0;i<results.size();i++){
	    		if(!results[i].isSuccess()){
	    			isSuccess = false;	
	    		}	
	    	}    	
    	}
    	return isSuccess;
    }
    
    //Description : Purpose of this method is to delete PM_Composition__c Records.
    public static boolean deletePmComposition(List<PM_Composition__c> lstPmCompToDelete){
    	boolean isSuccess = true;
    	if(lstPmCompToDelete.size()>0){
			Database.DeleteResult[] results = Database.delete(lstPmCompToDelete,true);
	    	for(Integer i=0;i<results.size();i++){
	    		if(!results[i].isSuccess()){
	    			isSuccess = false;	
	    		}	
	    	}    	
    	}
    	return isSuccess;
    }
    
    //Description : Purpose of this method is to delete PM_Physical_Properties__c Records.
    public static boolean deletePmPhysicalProperties(List<PM_Physical_Properties__c> lstPmPhyPropertiesDelete){
    	boolean isSuccess = true;
    	if(lstPmPhyPropertiesDelete.size() > 0){
    		Database.DeleteResult[] results = Database.delete(lstPmPhyPropertiesDelete,true);
    		for(Integer i=0;i<results.size();i++){
    			if(!results[i].isSuccess()){
    				isSuccess = false;	
    			}	
    		}
    	}
    	return isSuccess;
    }
    
    //Description : Purpose of this method is to delete PM_QA_Spec__c Records.
    public static boolean deletePmQaSpec(List<PM_QA_Spec__c> lstPmQaSpecToDelete){
    	boolean isSuccess = true;
    	if(lstPmQaSpecToDelete.size()>0){
			Database.DeleteResult[] results = Database.delete(lstPmQaSpecToDelete,true);
	    	for(Integer i=0;i<results.size();i++){
	    		if(!results[i].isSuccess()){
	    			isSuccess = false;	
	    		}	
	    	}    	
    	}
    	return isSuccess;
    }
}