global class ScheduledCaseSnapshot implements Schedulable {

 global void execute(SchedulableContext ctx) {
 RunQuery RunSnap = new RunQuery();
 //Batch size is 200, records will be split into batches 
 Database.ExecuteBatch(RunSnap,200);
 } 
}