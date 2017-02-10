/*Description : This class is used as a controller class for ProjectTabs VF component. Purpose of this class is to get, set and manipulate
Projects data
Created By : Mustafa 
Created Date : November 2016*/
public with sharing class  ProjectTabsController {
   
   	public static String prodId {get;set;}
    public static product__c prod;
    public Project__c projectRecord{get;set;}
    public static list<Where_Used__c> boms;
    public static list<PM_Mix_Instruction__c> mixIns;
    public static list<PM_Composition__c> pmCompos;
    public static list<PM_QA_Spec__c> pmQaQcSpecs;
    public static list<PM_Physical_Properties__c> pmPhProps;  
    public static list<PM_Application__c> pmApps;
    public static list<PM_Regulatory_Clearance__c> pmrcs;
    public static list<PM_Approved_Mfg_Plant__c> pmAmfgPlant;
    public static list<PM_Approved_WH__c> pmAWh;
    public static list<Product_Pkg__c> prdPkg;
    
    public ProjectTabsController(){
        if(projectRecord==null){
            prod = new Product__c();
            boms = new list<Where_Used__c>();
            mixIns =  new list<PM_Mix_Instruction__c>();
            pmCompos = new list<PM_Composition__c>();
            pmQaQcSpecs = new list<PM_QA_Spec__c>();
            pmPhProps = new list<PM_Physical_Properties__c>();
            pmApps = new list<PM_Application__c>();
            pmrcs = new  list<PM_Regulatory_Clearance__c>();
            pmAmfgPlant = new list<PM_Approved_Mfg_Plant__c>();
            pmAWh = new list<PM_Approved_WH__c>();
            prdPkg = new list<Product_Pkg__c>();
        }
    }
    
    /*Description : Purpose of this method is to get the product details*/
    public Product__c getProd(){
        if(projectRecord != null){
            prod= TurboPLMSelector.getProductById(projectRecord.Product__c);
        }
       
      return prod;
    }
    
    /*Description : Purpose of this method is to get the boms details*/
    public List<Where_Used__c> getfetchBoms(){
         if(projectRecord != null){
            boms= TurboPLMSelector.getBomsByProductId(projectRecord.Product__c);   
        }
        return boms;
    }
    
    /*Description : Purpose of this method is to get the Pm Mix Instruction details*/
    public List<PM_Mix_Instruction__c> getfetchPMMixInst(){
         if(projectRecord != null){
            mixIns= TurboPLMSelector.getPmMixInstructionByProductId(projectRecord.Product__c);   
        }
         return mixIns;
    }
    
    /*Description : Purpose of this method is to get the PM Composition details*/
    public List<PM_Composition__c> getfetchPMComposition(){
         if(projectRecord != null){
            pmCompos= TurboPLMSelector.getPmCompositionsByProductId(projectRecord.Product__c);   
        }
         return pmCompos;
    }
    
    /*Description : Purpose of this method is to get the Pm Qa/Qc Specs details*/
    public List<PM_QA_Spec__c> getfetchPmQaQcSpecs(){
         if(projectRecord != null){
            pmQaQcSpecs= TurboPLMSelector.getPmQaQcSpecsByProductId(projectRecord.Product__c);   
        }
         return pmQaQcSpecs;
    }
    
    /*Description : Purpose of this method is to get the Physical properties */
    public List<PM_Physical_Properties__c> getfetchPhProps(){
         if(projectRecord != null){
            pmPhProps= TurboPLMSelector.getPhyPropertiesByProductId(projectRecord.Product__c);   
        }
         return pmPhProps;
    }
    
    /*Description : Purpose of this method is to get the PM applicatin details */
    public List<PM_Application__c> getfetchPMApps(){
         if(projectRecord != null){
            pmApps= TurboPLMSelector.getPMApplication(projectRecord.Product__c);   
        }
         return pmApps;
    }
   
   /*Description : Purpose of this method is to get the regulatory clearance */
    public List<PM_Regulatory_Clearance__c> getfetchPMRegClearance(){
         if(projectRecord != null){
            pmrcs= TurboPLMSelector.getPMPMRegulatoryClearance(projectRecord.Product__c);   
        }
        return pmrcs;
    }
    
    /*Description : Purpose of this method is to get the Approved MFG plant*/
    public List<PM_Approved_Mfg_Plant__c> getfetchPmAppMfg(){
         if(projectRecord != null){
            pmAmfgPlant= TurboPLMSelector.getPmApprovedMfgPlantByProductId(projectRecord.Product__c);   
        }
        return pmAmfgPlant;
    }
    
     /*Description : Purpose of this method is to get the Approved WH*/   
    public List<PM_Approved_WH__c> getfetchPmApprWhProd(){
         if(projectRecord != null){
            pmAWh= TurboPLMSelector.getPmApprovedWhByProductId(projectRecord.Product__c);   
        }
        return pmAWh;
    }
    
   /*Description : Purpose of this method is to get the Approved product package*/
    public List<Product_Pkg__c> getfetchProdPkg(){
         if(projectRecord != null){
            prdPkg= TurboPLMSelector.getProductPkg(projectRecord.Product__c);   
        }
            return prdPkg;
    }
}