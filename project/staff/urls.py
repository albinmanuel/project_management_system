from django.contrib import admin
from django.urls import path
from .import views
from django.conf import settings

urlpatterns = [
    path('staff_dashboard/',views.staff_dashboard,name='staff_dashboard'),
    path('staff_profile/',views.staff_profile,name='staff_profile'),
    path('staff_tech/',views.staff_tech,name='staff_tech'), 
    path('add_stafftech/',views.add_stafftech,name='add_stafftech'),
    path('edit_stafftech/<int:tid>',views.edit_stafftech,name='edit_stafftech'),
    path('edited_stafftech/',views.edited_stafftech,name='edited_stafftech'),
    path('del_stafftech/<int:tid>',views.del_stafftech,name='del_stafftech'),
    path('new_prj/',views.new_prj,name='new_prj'),
    path('prj_details/<int:pgid>',views.prj_details,name='prj_details'),
    path('req_appr/<int:pgid>',views.req_appr,name='req_appr'),
    path('req_rej/<int:pgid>',views.req_rej,name='req_rej'),
    path('staff_project/',views.staff_project,name='staff_project'),
    path('staff_project_details/<int:pgid>',views.staff_prj_details,name='staff_prj_details'),
    path('project_deadline/',views.project_deadline,name='project_deadline'),
    path('deadline_details/',views.deadline_details,name='deadline_details'),
     path('update_project_mark/',views.update_project_mark,name='update_project_mark'),
     path('save_deadline_message/',views.save_deadline_message,name='save_deadline_message'),
     path('save_guide_message/',views.save_guide_message,name='save_guide_message'),
    
    

]
