/*Description : This class is used as a Domain class for Projects VF page, procurement Component. Purpose of this class is to perforn CRUD Operations.
Projects data
Created By : Mustafa
Created Date : November 2016*/
public with sharing class ProcurementDomain {

    /*Description : Purpose of this method is to save the project */ 
    public static boolean saveProcurementProduct(Product__c productRecord,boolean rawMaterial,boolean erpData){
		boolean isSuccess = true;
        List<Product__c> productLst = new List<Product__c>();
        productRecord.Procurement_RawMaterial__c = rawMaterial;
        productRecord.Procurement_Erp__c = erpData;
        productLst.add(productRecord);
        Database.UpsertResult[] results = Database.upsert(productLst,true);
    	for(Integer i=0;i<results.size();i++){
    		if(!results[i].isSuccess()){
    			isSuccess = false;	
    		}	
    	}
    	return isSuccess;
    }
    /*Description : Purpose of this method is to save/submit the project to Regulatory Clearance department.*/
    public static void  submitProjectToRegulatoryClearance(Project__c prjToUpsert){
        prjToUpsert.Approval_Status__c = 'Submitted';
        prjToUpsert.Department__c = 'Regulatory Clearance';
		upsert prjToUpsert;         
        
    }
}