/*Description : This class is used as a Domain class for Projects VF page, CreateProject Component. Purpose of this class is to perforn CRUD Operations.
Projects data
Created By : Mustafa
Created Date : November 2016*/

public with sharing class ProjectDomain {
    /*Description : Purpose of this method is to update actorId for reassigning approver of record.*/
    public static void updateProcessInstanceWorkItem(ProcessInstanceWorkItem varProcessInstanceWorkItem){
        update varProcessInstanceWorkItem;
    }
    
    /*Description : Purpose of this method is update Project details.*/
    public static void updateProject(Project__c project){
        update project;
    }
    
    /*Description : Purpose of this method is reassign the project to other user.*/
    public static void updateWorkItemList(List<ProcessInstanceWorkItem> lstWorkItemList){
        update lstWorkItemList;
    }
    /*Description : Purpose of this method is insert Shared Record for assigning to other user.*/
    public static void insertSharedRecord(Product__share shareProduct){
         Database.SaveResult sr = Database.insert(shareProduct,false);
    }
    
    /*Description : Purpose of this method is to save the product.*/
    public static void upsertProduct(Product__c prdtToUpsert){
        upsert prdtToUpsert;
    }
    
    /*Description : Purpose of this method is to save the project.*/
    public static boolean upsertProject(Project__c prjToUpsert){
        Database.UpsertResult result = Database.upsert(prjToUpsert);
        boolean isSuccess = result.isSuccess();
        return isSuccess;
    }
    
    /*Description : Purpose of this method is to save/submit the project to supply chain department.*/
    public static void  submitProjectToSupplyChain(Project__c prjToUpsert){
        prjToUpsert.Approval_Status__c = 'Submitted';
        prjToUpsert.Department__c = 'SC Opt';
		upsert prjToUpsert;         
        //Database.UpsertResult result = Database.upsert(prjToUpsert);
    	//boolean isSuccess = result.isSuccess();
    }
    /*Description : Purpose of this method is to save/submit the project to procurement department.*/
    public static void  submitProjectToProcurement(Project__c prjToUpsert){
        prjToUpsert.Approval_Status__c = 'Submitted';
        prjToUpsert.Department__c = 'Procurement';
		upsert prjToUpsert;         
    }
    
    /*Description : Purpose of this method is to save the PM Application.*/
    public static void upsertPMApplication(PM_Application__c PMApp){
    	upsert PMApp;    
    }
    
    /*Description : Purpose of this method is to save the Product package.*/
    public static void updateProductPkg(List<Product_Pkg__c> lstPkgSizeIds){
        upsert lstPkgSizeIds;
    }
    
    /*Description : Purpose of this method is to delete the Product package.*/
    public static void deleteProductPkgRecords(List<Product_Pkg__c> lstPkgSizeIds){
    	database.delete(lstPkgSizeIds);  
    }
    
    /*Description : Purpose of this method is to delete the PM Regulation.*/
    public static void deletePMRegClrRecords(List<PM_Regulatory_Clearance__c> lstChemRegulationIds){
    	database.delete(lstChemRegulationIds);	    
    }
    
    /*Description : Purpose of this method is to save the Product package.*/
    public static void insertProductPkg(List<Product_Pkg__c> lstProductPkg){
        insert lstProductPkg; 
    }
    
    /*Description : Purpose of this method is to save the PM Regulation Clearance.*/
    public static void insertPMRegClearance(List<PM_Regulatory_Clearance__c> lstPMregClearance){
    	upsert lstPMregClearance;     
    }
    
    /*Description : Purpose of this method is to delete the PM Regulation Clearance.*/
    public static void deletePmRegulatoryClearance(List<PM_Regulatory_Clearance__c> lstChemRegulationIds){
    	delete lstChemRegulationIds;	
    }
    
    /*Description : Purpose of this method is to upsert BOM.*/
    public static void upsertBom(List<Where_Used__c> lstBomToUpsert){
    	upsert lstBomToUpsert;
    }
    
    /*Description : Purpose of this method is to upsert PM_Composition__c Records.*/
    public static void upsertPmComp(List<PM_Composition__c> lstPmCompToUpsert){
    	upsert lstPmCompToUpsert;
    }
    
     /*Description : Purpose of this method is to upsert PM_Mix_Instruction__c Record.*/
    public static void upsertPmMixInstruction(PM_Mix_Instruction__c pmMixInstruction){
    	upsert pmMixInstruction;
    }
    
     /*Description : Purpose of this method is to upsert PM_Physical_Properties__c Records.*/
    public static void upsertPmPhysicalPrperties(List<PM_Physical_Properties__c> lstPmPhyProperties){
    	upsert lstPmPhyProperties; 	
    }
    
    /*Description : Purpose of this method is to upsert PM_QA_Spec__c Records.*/
    public static void upertPmQaSpec(List<PM_QA_Spec__c> lstPmQaSpec){
    	upsert lstPmQaSpec;
    }
    
    /*Description : Purpose of this method is to delete Where_Used__c Records.*/
    public static void deleteBoms(List<Where_Used__c> lstBomToDelete){
    	delete lstBomToDelete;
    }
    
    /*Description : Purpose of this method is to delete PM_Composition__c Records.*/
    public static void deletePmComposition(List<PM_Composition__c> lstPmCompToDelete){
    	delete lstPmCompToDelete;
    }
    
    /*Description : Purpose of this method is to delete PM_Mix_Instruction__c Record.*/
    public static void deletePmMixInstruction(PM_Mix_Instruction__c pmMixInstructionToDelete){
    	delete 	pmMixInstructionToDelete;
    }
    
    /*Description : Purpose of this method is to delete PM_Physical_Properties__c Records.*/
    public static void deletePmPhysicalProperties(List<PM_Physical_Properties__c> lstPmPhyPropertiesDelete){
    	delete lstPmPhyPropertiesDelete;	
    }
    
    /*Description : Purpose of this method is to delete PM_QA_Spec__c Records.*/
    public static void deletePmQaSpec(List<PM_QA_Spec__c> lstPmQaSpecToDelete){
    	delete lstPmQaSpecToDelete;
    }
}