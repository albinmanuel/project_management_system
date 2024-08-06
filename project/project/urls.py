"""
URL configuration for project project.

The urlpatterns list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.0/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path,include
from .import views
from .import api
from django.conf import settings

from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    path('',views.login,name='login'),
    path('administrator/',include('administrator.urls')),
    path('check_login',views.check_login,name="check_login"),
    path('forgot',views.forgot,name="forgot"),
    path('emailverify',views.email_verify,name="emailverify"),
    path('otpvalid',views.otpvalid,name="otpvalid"),
    path('changepassword',views.changepassword,name="changepassword"),
    path('staff/',include('staff.urls')),
    path('logout1',views.logout1,name='logout1'),
    path('get_batch',api.get_batch,name='get_batch'),
    path('check_login_student',api.check_login_student,name='check_login_student'),
    path('saveproject',api.saveproject,name='saveproject'),
    path('add_group',api.add_group,name='add_group'),
    path('add_members',api.add_members,name='add_members'),
    path('get_student',api.get_student,name='get_student'),
    path('get_project_group_members',api.get_project_group_members,name='get_project_group_members'),
    path('get_all_student',api.get_all_student,name='get_all_student'),
 path('get_all_student_projects',api.get_all_student_projects,name='get_all_student_projects'),
path('get_all_guides',api.get_all_guides,name='get_all_guides'),
path('add_project_guide',api.add_project_guide,name='add_project_guide'),
path('get_all_guides_by_pid',api.get_all_guides_by_pid,name='get_all_guides_by_pid'),
path('get_project_by_pid',api.get_project_by_pid,name='get_project_by_pid'),
path('get_staff_by_staff_id',api.get_staff_by_staff_id,name='get_staff_by_staff_id'),
path('get_staff_technologies_by_staff_id',api.get_staff_technologies_by_staff_id,name='get_staff_technologies_by_staff_id'),
path('get_allowed_student_project',api.get_allowed_student_project,name='get_allowed_student_project'),
path('add_task',api.add_task,name='add_task'),
path('get_task_by_project_id',api.get_task_by_project_id,name='get_task_by_project_id'),
path('delete_task',api.delete_task,name='delete_task'),
path('update_task_complete',api.update_task_complete,name='update_task_complete'),
path('upload_report',api.upload_report,name='upload_report'),
path('get_report_by_project_id',api.get_report_by_project_id,name='get_report_by_project_id'),
path('get_alert_message_by_pid',api.get_alert_message_by_pid,name='get_alert_message_by_pid'),

path('get_guide_message_by_pid',api.get_guide_message_by_pid,name='get_guide_message_by_pid'),


 

]+ static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)