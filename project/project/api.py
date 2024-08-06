from django.shortcuts import render,redirect
from project import models
import random
from django.contrib import messages
from django.core.mail import send_mail
from project.settings import EMAIL_HOST_USER
from django.http import HttpResponse, JsonResponse
from django.views.decorators.csrf import csrf_exempt
import json
from datetime import datetime

@csrf_exempt
def get_batch(request):
    all_batch = models.Batch.objects.all()
    batch_list = [{'batch_id': batch.batch_id, 'batch_title': batch.batch_title} for batch in all_batch]
    batch_json = json.dumps(batch_list)
    return HttpResponse(batch_json, content_type='application/json')

@csrf_exempt
def check_login_student(request):
    if request.method == 'POST':
        uname = request.POST.get("uname")
        password = request.POST.get("password")
        usertype = "student"
        
        login_info = models.Login.objects.filter(username=uname, password=password, user_type=usertype)
        
        if login_info.exists():  # Check if any matching records exist
            return JsonResponse({'status': True, 'message': 'login success'})
        else:
            return JsonResponse({'status': False, 'message': 'login failed'})

    # If the request method is not POST, return an error response
    return JsonResponse({'status': False, 'message': 'Invalid request method'})



@csrf_exempt
def saveproject(request):
    if request.method == 'POST':
        pname = request.POST.get("pname")
        abstract = request.POST.get("abstract")
        username=request.POST.get("username")
        student= models.Student.objects.filter(email=username).first()
        batch_id = student.batch_id
        sql="select * from project_group where group_id in(select fk_group_id from project_members m join student s on(m.student_id=s.student_id) where s.email='"+username+"')"
        project_groups = models.ProjectGroup.objects.raw(sql)
        if project_groups:
            project_group= project_groups[0]
            group_id = project_group.group_id
            
        
            project_details = models.Project(project_title=pname,abstract=abstract,batch_id=batch_id,fk_group_id=group_id,status='Send')
            project_details.save()
            if project_details:  # Check if any matching records exist
                return JsonResponse({'status': True, 'message': ' Project Successfully Created','project_id':project_details.project_id})
            else:
                return JsonResponse({'status': False, 'message': 'Project Creation Failed','project_id':''})
        else:
                return JsonResponse({'status': False, 'message': 'Please Create Group before saving Project','project_id':''})
    # If the request method is not POST, return an error response
    return JsonResponse({'status': False, 'message': 'Invalid request method','project_id':''})

@csrf_exempt
def add_group(request):
    if request.method == 'POST':
        group_title = request.POST.get("group_title")
        created_by =  request.POST.get("created_by")
      
        
        project_group = models.ProjectGroup(group_title=group_title,created_by=created_by)
        project_group.save()
        if project_group:  # Check if any matching records exist
            return JsonResponse({'status': True, 'message': ' Group Successfully Created','group_id':project_group.group_id})
        else:
            return JsonResponse({'status': False, 'message': 'Group Creation Failed'})

    # If the request method is not POST, return an error response
    return JsonResponse({'status': False, 'message': 'Invalid request method'})

@csrf_exempt
def add_members(request):
    if request.method == 'POST':
        username = request.POST.get("username")
        group_id =  request.POST.get("group_id")
        student=models.Student.objects.filter(email=username).first()
        exit_member_list= models.ProjectMembers.objects.filter(student_id=student.student_id,fk_group_id=group_id)
        if len(exit_member_list)==0:

            project_members = models.ProjectMembers(student_id=student.student_id,fk_group_id=group_id)
            project_members.save()
            return JsonResponse({'status': True, 'message': ' Group Member Successfully Created'})
          
        else:
            return JsonResponse({'status': False, 'message': 'Group Member Already exist'})

    # If the request method is not POST, return an error response
    return JsonResponse({'status': False, 'message': 'Invalid request method'})

@csrf_exempt
def get_student(request):
     batch_id=request.POST.get("batch_id")
     all_student = models.Student.objects.filter(batch_id=batch_id)
     student_list = [{'student_id': student.student_id, 'email': student.email,'register_no':student.register_no,'gender':student.gender} for student in all_student]
     student_json = json.dumps(student_list)
     return HttpResponse(student_json, content_type='application/json')
     
@csrf_exempt
def get_project_group_members(request):
    username= request.POST.get("email")
    print(username)
    sql="select * from project_group where group_id in(select fk_group_id from project_members m join student s on(m.student_id=s.student_id) where s.email='"+username+"')"
    project_groups = models.ProjectGroup.objects.raw(sql)
    if project_groups:
        project_group= project_groups[0]
        group_id = project_group.group_id
         
        group_title = project_group.group_title    
         
        qry="select * from project_members m join student s on(m.student_id=s.student_id) where fk_group_id="+str(group_id)+""
        project_members = models.ProjectMembers.objects.raw(qry);
        project_members_list = [{'student_id': student.student_id,'student_name': student.student_name, 'email': student.email,'register_no':student.register_no,'gender':student.gender} for student in project_members]
        group ={'group_id':group_id,'group_title':group_title }
        project_group_members={'status':True,'group':group,'team_members':project_members_list}
        project_group_members_json = json.dumps(project_group_members)
        
        return HttpResponse(project_group_members_json, content_type='application/json')


    else:
        project_group_members={'status':False}
        project_group_members_json = json.dumps(project_group_members)
        
        return HttpResponse(project_group_members_json, content_type='application/json')

@csrf_exempt
def get_all_student(request):
     email=request.POST.get("email")
      
     student = models.Student.objects.filter(email=email).first()
     all_student = models.Student.objects.filter(batch_id=student.batch_id)
     
     student_list = [{'student_id': student.student_id, 'student_name': student.student_name, 'email': student.email,'register_no':student.register_no,'gender':student.gender} for student in all_student]
     student_json = json.dumps(student_list)
     return HttpResponse(student_json, content_type='application/json')

@csrf_exempt
def get_all_student_projects(request):
    username= request.POST.get("email")
    all_projects=[] 
    sql="select * from project_group where group_id in(select fk_group_id from project_members m join student s on(m.student_id=s.student_id) where s.email='"+username+"')"
    project_groups = models.ProjectGroup.objects.raw(sql)
    if project_groups:
        project_group= project_groups[0]
        group_id = project_group.group_id    
         
        qry="select * from project p join project_group pg on(p.fk_group_id=pg.group_id) where fk_group_id="+str(group_id)+""
        projects = models.Project.objects.raw(qry);
        for i in projects:
            cat = {}
            for field_name, field_value in i.__dict__.items():
                
                if not field_name.startswith('_') and field_name != 'id':
                    cat[field_name] = field_value
            all_projects.append(cat) 
        
    return JsonResponse(all_projects, safe=False)

@csrf_exempt
def get_all_guides(request):
    
    all_guides=[] 
    staffs = models.Staff.objects.all()
    for i in staffs:
            cat = {}
            for field_name, field_value in i.__dict__.items():
                
                if not field_name.startswith('_') and field_name != 'id':
                    cat[field_name] = field_value
            all_guides.append(cat)  
        
    return JsonResponse(all_guides, safe=False)


@csrf_exempt
def get_all_guides_by_pid(request):
    pid= request.POST.get("project_id")
    all_guides=[] 
    sql="select * from project_guide pg join staff s on(s.staff_id=pg.staff_id) where pg.project_id="+str(pid)
    staffs = models.ProjectGuide.objects.raw(sql)
    for i in staffs:
            cat = {}
            for field_name, field_value in i.__dict__.items():
                
                if not field_name.startswith('_') and field_name != 'id':
                    cat[field_name] = field_value
            all_guides.append(cat)  
        
    return JsonResponse(all_guides, safe=False)

@csrf_exempt
def get_alert_message_by_pid(request):
    pid= request.POST.get("project_id")
    
    all_alert_messages=[] 
    sql="select * from project_guide pg join dead_line_alerts m on(pg.project_guide_id=m.fk_project_guide_id) where pg.project_id="+str(pid)
    staffs = models.DeadLineAlerts.objects.raw(sql)
    for i in staffs:
            cat = {}
            for field_name, field_value in i.__dict__.items():
                
                if not field_name.startswith('_') and field_name != 'id':
                    if field_value is None:
                        field_value = ''
                    cat[field_name] = field_value
            all_alert_messages.append(cat)  
        
    return JsonResponse(all_alert_messages, safe=False)

@csrf_exempt
def get_guide_message_by_pid(request):
    pid= request.POST.get("project_id")
     
    all_alert_messages=[] 
    sql="select * from project_guide pg join guide_messages m on(pg.project_guide_id=m.fk_project_guide_id) where pg.project_id="+str(pid)
    staffs = models.GuideMessages.objects.raw(sql)
    for i in staffs:
            cat = {}
            for field_name, field_value in i.__dict__.items():
                
                if not field_name.startswith('_') and field_name != 'id':
                    if field_value is None:
                        field_value = ''
                    cat[field_name] = field_value
            all_alert_messages.append(cat)  
        
    return JsonResponse(all_alert_messages, safe=False)

@csrf_exempt
def add_project_guide(request):
    if request.method == 'POST':
        project_id = request.POST.get("project_id")
        staff_id =  request.POST.get("staff_id")
        status='requested'
        cdate= datetime.now().date()
        
        project_group = models.ProjectGuide(project_id=project_id,staff_id=staff_id,status=status,requested_date=cdate)
        project_group.save()
        if project_group:  # Check if any matching records exist
            return JsonResponse({'status': True, 'message': ' Guide Successfully requested'})
        else:
            return JsonResponse({'status': False, 'message': ' Request Failed'})

    # If the request method is not POST, return an error response
    return JsonResponse({'status': False, 'message': 'Invalid request method'})

@csrf_exempt
def get_project_by_pid(request):
    pid= request.POST.get("project_id")
     
    project = models.Project.objects.get(project_id=pid)

    cat = {}
    for field_name, field_value in project.__dict__.items():
                
        if not field_name.startswith('_') and field_name != 'id':
            cat[field_name] = field_value
              
        
    return JsonResponse(cat, safe=False)

@csrf_exempt
def get_staff_by_staff_id(request):
    staff_id= request.POST.get("staff_id")
     
    project = models.Staff.objects.get(staff_id=staff_id)

    cat = {}
    for field_name, field_value in project.__dict__.items():
                
        if not field_name.startswith('_') and field_name != 'id':
            cat[field_name] = field_value
              
        
    return JsonResponse(cat, safe=False)

@csrf_exempt
def get_staff_technologies_by_staff_id(request):
    staff_id= request.POST.get("staff_id")
    sql="select * from technologies t join staff_technologies st on(st.tech_id=t.tech_id) where staff_id="+str(staff_id) 
    project = models.StaffTechnologies.objects.raw(sql)

    all_guides=[] 
     
    for i in project:
            cat = {}
            for field_name, field_value in i.__dict__.items():
                
                if not field_name.startswith('_') and field_name != 'id':
                    cat[field_name] = field_value
            all_guides.append(cat)  
        
    return JsonResponse(all_guides, safe=False)

@csrf_exempt
def get_allowed_student_project(request):
    username= request.POST.get("email")
    all_projects=[] 
    sql="select * from project_group where group_id in(select fk_group_id from project_members m join student s on(m.student_id=s.student_id) where s.email='"+username+"')"
    project_groups = models.ProjectGroup.objects.raw(sql)
    if project_groups:
        project_group= project_groups[0]
        group_id = project_group.group_id    
         
        qry="select * from project p join project_group pg on(p.fk_group_id=pg.group_id) where p.status='Allowed' and fk_group_id="+str(group_id)+""
        projects = models.Project.objects.raw(qry);
        cat = {}
        for i in projects:
           
            for field_name, field_value in i.__dict__.items():
                
                if not field_name.startswith('_') and field_name != 'id':
                    cat[field_name] = field_value
            
        
    return JsonResponse(cat, safe=False)


@csrf_exempt
def get_task_by_project_id(request):
    project_id= request.POST.get("project_id")
    project = models.Task.objects.filter(fk_project_id=project_id)

    all_guides=[] 
     
    for i in project:
            cat = {}
            for field_name, field_value in i.__dict__.items():
                
                if not field_name.startswith('_') and field_name != 'id':
                    cat[field_name] = field_value
            all_guides.append(cat)  
        
    return JsonResponse(all_guides, safe=False)

@csrf_exempt
def add_task(request):
    if request.method == 'POST':
        project_id = request.POST.get("project_id")
        task_name =  request.POST.get("task_name")
        status='created'
         
        
        project_group = models.Task(fk_project_id=project_id,task_status=status,task_name=task_name)
        project_group.save()
        if project_group:  # Check if any matching records exist
            return JsonResponse({'status': True, 'message': ' Task Successfully created'})
        else:
            return JsonResponse({'status': False, 'message': ' saving Failed'})

    # If the request method is not POST, return an error response
    return JsonResponse({'status': False, 'message': 'Invalid request method'})

@csrf_exempt
def get_task_by_project_id(request):
    project_id= request.POST.get("project_id")
    project = models.Task.objects.filter(fk_project_id=project_id)

    all_guides=[] 
     
    for i in project:
            cat = {}
            for field_name, field_value in i.__dict__.items():
                
                if not field_name.startswith('_') and field_name != 'id':
                    cat[field_name] = field_value
            all_guides.append(cat)  
        
    return JsonResponse(all_guides, safe=False)

@csrf_exempt
def delete_task(request):
    if request.method == 'POST':
        task_id = request.POST.get("task_id")
         
         
        
        task = models.Task.objects.get(task_id=task_id);
        
        if task: 
            task.delete() # Check if any matching records exist
            return JsonResponse({'status': True, 'message': ' Task Successfully deleted'})
        else:
            return JsonResponse({'status': False, 'message': ' deletion Failed'})

    # If the request method is not POST, return an error response
    return JsonResponse({'status': False, 'message': 'Invalid request method'})

@csrf_exempt
def update_task_complete(request):
    if request.method == 'POST':
        task_id = request.POST.get("task_id")
         
         
        
        task = models.Task.objects.get(task_id=task_id);
        
        if task: 
            task.task_status='completed'
            task.save() # Check if any matching records exist
            return JsonResponse({'status': True, 'message': ' Task Successfully updated'})
        else:
            return JsonResponse({'status': False, 'message': ' update Failed'})

    # If the request method is not POST, return an error response
    return JsonResponse({'status': False, 'message': 'Invalid request method'})


@csrf_exempt
def upload_report(request):
    if request.method == 'POST' and request.FILES.get('file'):
        report_title = request.POST.get('report_title')
        project_id = request.POST.get('project_id')
        uploaded_file = request.FILES['file']


        # Save the file to the server
        with open(f'media/{uploaded_file.name}', 'wb+') as destination:
            for chunk in uploaded_file.chunks():
                destination.write(chunk)
        report= models.ProjectReport(report_title=report_title,file_name=uploaded_file.name,fk_project_id=project_id)
        report.save()
        # Here you can perform further processing, such as saving the file path and other details to the database

        return JsonResponse({'message': 'Report uploaded successfully'}, status=200)

    return JsonResponse({'error': 'Invalid request'}, status=400)

@csrf_exempt
def get_report_by_project_id(request):
    project_id= request.POST.get("project_id")
    project = models.ProjectReport.objects.filter(fk_project_id=project_id)

    all_guides=[] 
     
    for i in project:
            cat = {}
            for field_name, field_value in i.__dict__.items():
                
                if not field_name.startswith('_') and field_name != 'id':
                    cat[field_name] = field_value
            all_guides.append(cat)  
        
    return JsonResponse(all_guides, safe=False)