from django.shortcuts import render,redirect
from project import models
from django.contrib import messages
from datetime import date
def staff_dashboard(request):
    return render(request,'staff_user/staff.html') 

def staff_profile(request):
    email= request.session['email']
    profile= models.Staff.objects.filter(email=email).first()
    context = {"profile":profile}
    return render(request,'staff_user/staff_profile.html',context) 

def staff_tech(request):
    obj=models.Technologies.objects.all
    context={'tech_list':obj}
    return render(request,'staff_user/staff_tech.html',context) 

def add_stafftech(request):
    tech= request.POST['tname']
    existing_tech=models.Technologies.objects.filter(tech_name=tech).first()
    if existing_tech:
        messages.error(request,'This technology already exists in the system')
        return redirect ('staff_tech') 
    obj=models.Technologies(tech_name=tech)
    obj.save()
    return redirect ('staff_tech')

def edit_stafftech(request,tid):
    obj=models.Technologies.objects.get(tech_id=tid)
    context={
              'tname':obj
            }
    return render(request,'staff_user/edit_stafftech.html',context)

def edited_stafftech(request):
    tname=request.POST['tname']
    tid=request.POST['tid']
    obj=models.Technologies.objects.get(tech_id=tid)
    obj.tech_name=tname
    obj.save()
    return redirect('staff_tech')

def del_stafftech(request,tid):
    obj=models.Technologies.objects.get(tech_id=tid)
    obj.delete()
    return redirect('staff_tech')

def new_prj(request):
    email= request.session['email']
    profile= models.Staff.objects.filter(email=email).first()
    staff_id=profile.staff_id
    obj=models.Project.objects.raw("select * from batch as b  join project as p on (b.batch_id=p.batch_id) join project_guide as pg on (pg.project_id=p.project_id) where pg.status='Requested' and staff_id=" +str(staff_id))
    context={ 'prjlist': obj
             
    }
    return render(request,'staff_user/new_requests.html',context)

def prj_details(request,pgid):
    obj=models.ProjectGuide.objects.get(project_guide_id=pgid)
    project_id=obj.project_id
    obj1=models.Project.objects.raw("select * from batch as b join project as p on b.batch_id=p.batch_id where project_id=" +str(project_id))
    obj2=models.ProjectMembers.objects.raw("select * from student as s join project_members as pm on s.student_id=pm.student_id join project as p on p.fk_group_id=pm.fk_group_id where project_id=" +str(project_id))
    context={
        'prjlist':obj1[0],
        'student':obj2,
        'prjguide':obj
    }

    return render(request,'staff_user/project_details.html',context)

def req_appr(request,pgid):
    obj = models.ProjectGuide.objects.get(project_guide_id=pgid)
    obj.status = 'Approved'
    obj.save()
    return redirect('new_prj')

def req_rej(request,pgid):
    obj = models.ProjectGuide.objects.get(project_guide_id=pgid)
    obj.status = 'Rejected'
    obj.save()
    return redirect('new_prj')


def staff_project(request):
    email= request.session['email']
    profile= models.Staff.objects.filter(email=email).first()
    staff_id=profile.staff_id
    obj=models.Project.objects.raw("select * from batch as b  join project as p on (b.batch_id=p.batch_id) join project_guide as pg on (pg.project_id=p.project_id) where pg.status='Approved' and staff_id=" +str(staff_id))
    context={ 'prjlist': obj
             
    }
    return render(request,'staff_user/staff_project.html',context)


def staff_prj_details(request,pgid):
    obj=models.ProjectGuide.objects.get(project_guide_id=pgid)
    dead_messages=models.DeadLineAlerts.objects.filter(fk_project_guide_id=pgid)
    guide_messages=models.GuideMessages.objects.filter(fk_project_guide_id=pgid)
    project_id=obj.project_id
    obj1=models.Project.objects.raw("select * from batch as b join project as p on b.batch_id=p.batch_id where project_id=" +str(project_id))
    obj2=models.ProjectMembers.objects.raw("select * from student as s join project_members as pm on s.student_id=pm.student_id join project_group pg on(pg.group_id=pm.fk_group_id) join project p on(p.fk_group_id=pg.group_id) where project_id=" +str(project_id))
    reports=models.ProjectReport.objects.filter(fk_project_id=project_id)
    context={
        'prjlist':obj1[0],
        'student':obj2,
        'prjguide':obj,
        'reports':reports,
        'dead_messages':dead_messages,
        'guide_messages':guide_messages
        
    }

    return render(request,'staff_user/staff_prj_details.html',context)

def project_deadline(request):
    obj=models.Batch.objects.all()
    context={
          'blist': obj
    }
    return render(request, 'staff_user/project_deadline.html',context)

def deadline_details(request):
    bid=request.POST['bid']
    if bid=='none':
        return redirect('project_deadline')
    obj2=models.Batch.objects.all()
    obj=models.ProjectTimeline.objects.filter(batch_id=bid)
    context={
        'dlist':obj,
        'blist': obj2
    }

    return render(request, 'staff_user/project_deadline.html',context)



def update_project_mark(request):
    report_id=request.POST['report_id']
    mark=request.POST['mark']
    project_guide_id=request.POST['project_guide_id']
    
    obj2=models.ProjectReport.objects.get(report_id=report_id)
    obj2.mark=mark
    obj2.save()
    messages.success(request,'Mark updated')
    return redirect('staff_prj_details',pgid=project_guide_id)


def save_deadline_message(request):
    current_date = date.today()
    end_date=request.POST['end_date']
    message=request.POST['message']
    project_guide_id=request.POST['project_guide_id']
    
    deadline_alert = models.DeadLineAlerts()

        # Set the values for the object
    deadline_alert.message = message
    deadline_alert.fk_project_guide_id = project_guide_id
    deadline_alert.posted_date = current_date
    deadline_alert.end_date = end_date  # Assuming end_date should be the same as posted_date

        # Save the object
    deadline_alert.save()
    messages.success(request,'Deadline added')
    return redirect('staff_prj_details',pgid=project_guide_id)


def save_guide_message(request):
    current_date = date.today() 
    message=request.POST['message']
    project_guide_id=request.POST['project_guide_id']
    
    deadline_alert = models.GuideMessages()

        # Set the values for the object
    deadline_alert.content = message
    deadline_alert.fk_project_guide_id = project_guide_id
    deadline_alert.posted_date = current_date
    deadline_alert.sent_by="guide"
     
        # Save the object
    deadline_alert.save()
    messages.success(request,'Message added')
    return redirect('staff_prj_details',pgid=project_guide_id)

