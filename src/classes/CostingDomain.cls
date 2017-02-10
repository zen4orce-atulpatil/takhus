/*Description : This class is used as a Domain class for Projects VF page, costing VF component. Purpose of this class is to perforn CRUD Operations.
Projects data
Created By : Mustafa
Created Date : November 2016*/
public class CostingDomain {

    /*Description : Purpose of this method is to save the project */
     public static boolean saveCostingProduct(Product__c productRecord,boolean erpData){
		boolean isSuccess = true;
        List<Product__c> productLst = new List<Product__c>();
        productRecord.Costing_ERP__c = erpData;
        productLst.add(productRecord);
        Database.UpsertResult[] results = Database.upsert(productLst,true);
    	for(Integer i=0;i<results.size();i++){
    		if(!results[i].isSuccess()){
    			isSuccess = false;	
    		}	
    	}
    	return isSuccess;
    }
        
    /*Description : Purpose of this method is to save the project */
    public static boolean saveCostingProject(Project__c projectRecord){
        boolean isSuccess = true;
        projectRecord.Status__c='Completed';
        Database.UpsertResult results = Database.upsert(projectRecord);
      	return isSuccess;      
    }
}