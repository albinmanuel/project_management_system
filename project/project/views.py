from django.shortcuts import render,redirect
from project import models
import random
from django.contrib import messages
from django.core.mail import send_mail
from project.settings import EMAIL_HOST_USER
from django.http import HttpResponse, JsonResponse
from django.views.decorators.csrf import csrf_exempt
import json
from django.contrib.auth import authenticate, login, logout
def login(request):
    return render(request,'login/index.html')


def check_login(request):
    uname=request.POST["uname"]
    password=request.POST["password"]
    login_info=models.Login.objects.filter(username=uname,password=password)
    for i in login_info:
        if i.username==uname and i.password==password:
            if i.user_type=="admin":
                request.session['email']=i.username
                return redirect('../administrator/administrator')
            elif i.user_type=="staff":
                request.session['email']=i.username
                return redirect('../staff/staff_dashboard')

    messages.error(request,'INVALID username or password')
    return redirect('login') 
            


def forgot(request):
    return render(request,'login/forgot.html')        


def email_verify(request):
    if request.method=='POST':
       mail=request.POST['uname']   
       loginfo=models.Login.objects.filter(username=mail)    
       for i in loginfo:
           if i.username==mail:
               otp=str(random.randint(1000,9999))
               request.session['otp']=otp
               request.session['email']=i.username
               subject='password resetting'
               message='Your OTP is:'+ otp
               email_id=request.session['email']
               send_mail(subject,message,EMAIL_HOST_USER,[email_id],fail_silently=False)
               return render(request,'login/otp.html')
            
           else:
                messages.error(request,'INVALID EMAIL')
                return redirect('forgot')
       messages.error(request,'INVALID EMAIL')
       return redirect('forgot') 
     
def otpvalid(request):
    if request.method=='POST':
        otp_now=request.POST['otp_code']
        otp=request.session['otp']
        if otp_now==otp:
            return render(request,'login/changepassword.html')
        else:
            messages.error(request,'INVALID DATA')
    
    messages.error(request,'INVALID DATA')

def changepassword(request):
    if request.method=='POST':
        otpmail=request.session['email']
        np=request.POST['npassword']
        rp=request.POST['cnpassword']
        if np==rp:
            log=models.Login.objects.filter(username=otpmail)
            log.update(password=np)
            return redirect('login')




def logout1(request):

    return  redirect('login')