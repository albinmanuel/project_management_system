from django.shortcuts import render,redirect
from project import models
from django.contrib import messages

def administrator(request):
    return render(request,'admin/admin.html')

def chngpassword(request):
    return render(request,'admin/changepassword.html')

def updtpassword(request):
    if request.method=='POST':
        email=request.session['email']
        op=request.POST['opassword']
        obj= models.Login.objects.get(username=email)
        if op==obj.password:
            np=request.POST['npassword']
            cp=request.POST['cnpassword']
            if np==cp:
                obj.password = np
                obj.save()

                return redirect('login')
            
def courses(request):
    obj=models.Course.objects.all()
    context={'course_list':obj}
    return render(request,'courses/courses.html',context)

def addcourse(request):
    course= request.POST['cname']
    existing_course=models.Course.objects.filter(course_name=course).first()
    if existing_course:
        messages.error(request,'This Course already exists in the system !!!')
        return redirect ('courses')

    obj=models.Course(course_name=course)
    obj.save()
    return redirect ('courses')

def editcourse(request,cid):
    obj=models.Course.objects.get(course_id=cid)
    context={
              'coursename':obj
            }
    return render(request,'courses/editcourse.html',context)

def editedcourse(request):
    cname=request.POST['cname']
    cid=request.POST['cid']
    obj=models.Course.objects.get(course_id=cid)
    obj.course_name=cname
    obj.save()
    return redirect('courses')

def delcourse(request,cid):
    obj=models.Course.objects.get(course_id=cid)
    obj_course=models.Batch.objects.filter(course_id=cid).count()
    if obj_course==0:
        obj.delete()
        messages.success(request,'Sucessfull !!!')
        return redirect('courses')
    messages.error(request,'This Course has a batch in existance')
    return redirect('courses')

def batch(request):
    course=models.Course.objects.all()
    batch=models.Batch.objects.raw("select * from course as c join batch as b on c.course_id=b.course_id")
    context={
             'clist':course,
             'blist':batch
            }
    return render(request,'batch/batch.html',context)

def addbatch(request):
    cid=request.POST['cid']
    batch=request.POST['batch']
    existing_batch=models.Batch.objects.filter(batch_title=batch).first()
    if existing_batch:
        messages.error(request,'This Batch already exists in the system !!!')
        return redirect ('batch')
    obj_batch=models.Batch(batch_title=batch,course_id=cid)
    obj_batch.save()
    return redirect("batch")

def editbatch(request,bid):
    batch=models.Batch.objects.get(batch_id=bid)
    context={
            'blist':batch
    }
    return render(request,'batch/editbatch.html',context)

def update_batch(request):
    bname=request.POST['batch']
    bid=request.POST['bid']
    newbatch=models.Batch.objects.get(batch_id=bid)
    newbatch.batch_title=bname
    newbatch.save()
    return redirect('batch')

def delete_batch(request,bid):
    obj=models.Batch.objects.get(batch_id=bid)
    obj_student=models.Student.objects.filter(batch_id=bid).count()
    if obj_student==0:
        obj.delete()
        messages.success(request,'Sucessfull !!!')
        return redirect('batch')
    messages.error(request,'This Batch has a student in existance')
    return redirect('batch')

def student(request):
    obj=models.Batch.objects.all()
    std=models.Student.objects.raw("select * from batch as b join student as s on b.batch_id=s.batch_id")
    context={'blist':obj,
             'slist':std
             }
    return render(request,'student/student.html',context)

def addstudent(request):
    name= request.POST['name']
    rnumber= request.POST['rnumber']
    anumber= request.POST['anumber']
    gender= request.POST['gender']
    pnumber= request.POST['pnumber']
    address= request.POST['address']
    email= request.POST['email']
    batch= request.POST['bid']
    password= request.POST['Password']
    existing_student=models.Login.objects.filter(username=email).first()
    if existing_student:
        messages.error(request,'This Student already exists in the system !!!')
        return redirect ('student')
    obj=models.Student(student_name=name,register_no=rnumber,admission_no=anumber,gender=gender,phone_no=pnumber,address=address,email=email,batch_id=batch)
    obj.save()
    obj2=models.Login(username=email,password=password,user_type='student')
    obj2.save()
    return redirect ('student')

def editstudent(request,sid):
    obj=models.Student.objects.get(student_id=sid)
    oby=models.Batch.objects.all()
    context={ 'blist':oby,
              'stdnt':obj
            }
    return render(request,'student/editstudent.html',context)

def editedstudent(request):
    name= request.POST['name']
    rnumber= request.POST['rnumber']
    anumber= request.POST['anumber']
    gender= request.POST['gender']
    pnumber= request.POST['pnumber']
    address= request.POST['address']
    batch= request.POST['bid']
    sid=request.POST['sid']
    obj=models.Student.objects.get(student_id=sid)
    obj.student_name=name
    obj.register_no=rnumber
    obj.admission_no=anumber
    obj.gender=gender
    obj.phone_no=pnumber
    obj.address=address
    obj.batch_id=batch
    obj.save()
    return redirect('student')

def delstudent(request,sid):
    obj=models.Student.objects.get(student_id=sid)
    obj2=models.Login.objects.get(username=obj.email)
    obj2.delete()
    obj.delete()
    return redirect('student')

def technologies(request):
    obj=models.Technologies.objects.all
    context={'tech_list':obj}
    return render(request,'technologies/technologies.html',context)

def addtechnologies(request):
    tech= request.POST['tname']
    existing_tech=models.Technologies.objects.filter(tech_name=tech).first()
    if existing_tech:
        messages.error(request,'This technology already exists in the system')
        return redirect ('technologies') 
    obj=models.Technologies(tech_name=tech)
    obj.save()
    return redirect ('technologies')

def edittech(request,tid):
    obj=models.Technologies.objects.get(tech_id=tid)
    context={
              'tname':obj
            }
    return render(request,'technologies/edittech.html',context)

def editedtech(request):
    tname=request.POST['tname']
    tid=request.POST['tid']
    obj=models.Technologies.objects.get(tech_id=tid)
    obj.tech_name=tname
    obj.save()
    return redirect('technologies')

def deltech(request,tid):
    obj=models.Technologies.objects.get(tech_id=tid)
    obj.delete()
    return redirect('technologies')

def staff(request):
    obj=models.Staff.objects.all
    context={'slist':obj
            }
    return render(request,'staff/staff.html',context)

def addstaff(request):
    name= request.POST['sname']
    address= request.POST['saddress']
    phone= request.POST['sphone']
    gender= request.POST['sgender']
    email= request.POST['semail']
    status= request.POST['sstatus']
    password= request.POST['spass']
    existing_staff=models.Login.objects.filter(username=email).first()
    if existing_staff:
         messages.error(request,'Staff already exists in the system !!!')
         return redirect('staff')
    obj=models.Staff(name=name,address=address,phone=phone,email=email,gender=gender,status=status)
    obj.save()
    obj2=models.Login(username=email,password=password,user_type='staff')
    obj2.save()
    return  redirect('staff')

def stafftech(request,sid):
    obj=models.StaffTechnologies.objects.raw("select * from technologies as t join staff_technologies as st on t.tech_id=st.tech_id where st.staff_id="+str(sid))
    obj2=models.Technologies.objects.all
    obj3=models.Staff.objects.get(staff_id=sid)
    context ={
        'techlist':obj,
        'techname':obj2,
        'stafflist': obj3
    }
    return render(request,'staff/stafftech.html', context)

def addstafftech(request):
    tid=request.POST['tid']
    sid=request.POST['staffid']
    existing_tech=models.StaffTechnologies.objects.raw("select * from staff_technologies where tech_id="+str(tid)+ " and staff_id="+str(sid))
    if existing_tech:
         messages.error(request,'Staff Technology already exists in the system !!!')
         return redirect('stafftech',sid)
    obj=models.StaffTechnologies(tech_id=tid,staff_id=sid)
    obj.save()
    return  redirect('stafftech',sid)

def delstafftech(request,tid,sid):
    obj=models.StaffTechnologies.objects.get(tech_id=tid,staff_id=sid)
    obj.delete()
    return redirect('stafftech',sid)


def editstaff(request,sid):
    obj=models.Staff.objects.get(staff_id=sid)
    context={ 'slist':obj}
    return render(request,'staff/editstaff.html',context)

def editedstaff(request):
    name= request.POST['sname']
    address= request.POST['saddress']
    phone= request.POST['sphone']
    gender= request.POST['sgender']
    status= request.POST['sstatus']
    sid=request.POST['sid']
    obj=models.Staff.objects.get(staff_id=sid)
    obj.name=name
    obj.address=address
    obj.phone=phone
    obj.gender=gender
    obj.status=status
    obj.save()
    return redirect('staff')

def delstaff(request,sid):
    obj=models.Staff.objects.get(staff_id=sid)
    obj2=models.Login.objects.get(username=obj.email)
    obj.delete()
    obj2.delete()
    return redirect('staff')

def prjrequests(request):
    obj=models.Project.objects.raw("select * from batch as b  join project as p on b.batch_id=p.batch_id where p.status='Send'")
    context={ 'prjlist': obj
             
    }
    return render(request,'project_requests/prjrequests.html',context)

def prjapprove(request,pid ):
    obj = models.Project.objects.get(project_id=pid)
    obj.status = 'Allowed'
    obj.save()
    return redirect('prjrequests')


def prjreject(request,pid):
    obj = models.Project.objects.get(project_id=pid)
    obj.status = 'Refused'
    obj.save()
    context={
        'prjlist':obj
    }
    return render(request,'project_requests/prjremarks.html',context)

def prjremarks(request, pid):
    remarks= request.POST['prjremarks']
    pid=request.POST['pid']
    obj=models.Project.objects.get(project_id=pid)
    obj.remarks=remarks
    obj.save()
    return redirect('prjrequests')

def timeline(request):
    obj=models.Batch.objects.all
    project=models.ProjectTimeline.objects.raw("select * from batch as b join project_timeline as p on b.batch_id=p.batch_id")
    context={'blist':obj,
             'prj':project }
    return render(request,'timeline/timeline.html',context)

def addtimeline(request):
    bid=request.POST['bid']
    module=request.POST['module']
    date=request.POST['date']
    obj_batch=models.ProjectTimeline(batch_id=bid,module=module,deadline=date)
    obj_batch.save()
    return redirect("timeline")

def edittimeline(request,pid):
    oby=models.ProjectTimeline.objects.get(timeline_id=pid)
    obj=models.Batch.objects.all()
    context={ 'plist':oby,
              'blist':obj
            }
    return render(request,'timeline/edittimeline.html',context)

def editedtimeline(request):
    bid=request.POST['bid']
    pid=request.POST['pid']
    module=request.POST['module']
    date=request.POST['date']
    obj=models.ProjectTimeline.objects.get(timeline_id=pid)
    obj.batch_id=bid
    obj.module=module
    obj.deadline=date
    obj.save()
    return redirect("timeline")

def deltimeline(request,tid):
    obj=models.ProjectTimeline.objects.get(timeline_id=tid)
    obj.delete()
    return redirect('timeline')

def logout_view(request):
    # logout(request)
    if 'login' in request.session:
        del request.sessionn['login']
    request.session.flush()
    return redirect('login')


def project_mark(request):
    Batch=models.Batch.objects.all
    context={
             'batch':Batch }
    if request.method == 'POST':
        bid = request.POST.get('bid')
        sql="select * from project p join project_report pr on(p.project_id=pr.fk_project_id) where status='Allowed' and batch_id="+str(bid)
        mark_list=models.Project.objects.raw(sql)
        for mark in mark_list:
            fk_group_id = mark.fk_group_id
            members= models.Student.objects.raw("select * from student s join project_members m on(s.student_id=m.student_id) where fk_group_id="+str(fk_group_id))
            mark.teams = members;
        context['mark_list'] = mark_list
    return render(request,'admin/project_mark.html',context)

