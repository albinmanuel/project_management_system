# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models


class AuthGroup(models.Model):
    name = models.CharField(unique=True, max_length=150)

    class Meta:
        managed = False
        db_table = 'auth_group'


class AuthGroupPermissions(models.Model):
    id = models.BigAutoField(primary_key=True)
    group = models.ForeignKey(AuthGroup, models.DO_NOTHING)
    permission = models.ForeignKey('AuthPermission', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_group_permissions'
        unique_together = (('group', 'permission'),)


class AuthPermission(models.Model):
    name = models.CharField(max_length=255)
    content_type = models.ForeignKey('DjangoContentType', models.DO_NOTHING)
    codename = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'auth_permission'
        unique_together = (('content_type', 'codename'),)


class AuthUser(models.Model):
    password = models.CharField(max_length=128)
    last_login = models.DateTimeField(blank=True, null=True)
    is_superuser = models.IntegerField()
    username = models.CharField(unique=True, max_length=150)
    first_name = models.CharField(max_length=150)
    last_name = models.CharField(max_length=150)
    email = models.CharField(max_length=254)
    is_staff = models.IntegerField()
    is_active = models.IntegerField()
    date_joined = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'auth_user'


class AuthUserGroups(models.Model):
    id = models.BigAutoField(primary_key=True)
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)
    group = models.ForeignKey(AuthGroup, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_user_groups'
        unique_together = (('user', 'group'),)


class AuthUserUserPermissions(models.Model):
    id = models.BigAutoField(primary_key=True)
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)
    permission = models.ForeignKey(AuthPermission, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_user_user_permissions'
        unique_together = (('user', 'permission'),)


class Batch(models.Model):
    batch_id = models.AutoField(primary_key=True)
    batch_title = models.CharField(max_length=200)
    course_id = models.IntegerField()

    class Meta:
        managed = False
        db_table = 'batch'


class Course(models.Model):
    course_id = models.AutoField(primary_key=True)
    course_name = models.CharField(max_length=200)

    class Meta:
        managed = False
        db_table = 'course'


class DeadLineAlerts(models.Model):
    deadline_id = models.AutoField(primary_key=True)
    fk_project_guide_id = models.IntegerField()
    message = models.TextField()
    posted_date = models.DateField()
    end_date = models.DateField()

    class Meta:
        managed = False
        db_table = 'dead_line_alerts'


class DjangoAdminLog(models.Model):
    action_time = models.DateTimeField()
    object_id = models.TextField(blank=True, null=True)
    object_repr = models.CharField(max_length=200)
    action_flag = models.PositiveSmallIntegerField()
    change_message = models.TextField()
    content_type = models.ForeignKey('DjangoContentType', models.DO_NOTHING, blank=True, null=True)
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'django_admin_log'


class DjangoContentType(models.Model):
    app_label = models.CharField(max_length=100)
    model = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'django_content_type'
        unique_together = (('app_label', 'model'),)


class DjangoMigrations(models.Model):
    id = models.BigAutoField(primary_key=True)
    app = models.CharField(max_length=255)
    name = models.CharField(max_length=255)
    applied = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'django_migrations'


class DjangoSession(models.Model):
    session_key = models.CharField(primary_key=True, max_length=40)
    session_data = models.TextField()
    expire_date = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'django_session'


class GuideMessages(models.Model):
    message_id = models.AutoField(primary_key=True)
    fk_project_guide_id = models.IntegerField()
    content = models.TextField()
    posted_date = models.DateField()
    sent_by = models.CharField(max_length=200)

    class Meta:
        managed = False
        db_table = 'guide_messages'


class Login(models.Model):
    username = models.CharField(primary_key=True, max_length=200)
    password = models.CharField(max_length=200)
    user_type = models.CharField(max_length=20)

    class Meta:
        managed = False
        db_table = 'login'


class Project(models.Model):
    project_id = models.AutoField(primary_key=True)
    project_title = models.CharField(max_length=200)
    abstract = models.CharField(max_length=200)
    batch_id = models.IntegerField()
    status = models.CharField(max_length=200)
    remarks = models.CharField(max_length=500)
    fk_group_id = models.IntegerField()

    class Meta:
        managed = False
        db_table = 'project'


class ProjectGroup(models.Model):
    group_id = models.AutoField(primary_key=True)
    group_title = models.CharField(max_length=40)
    created_by = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'project_group'


class ProjectGuide(models.Model):
    project_guide_id = models.AutoField(primary_key=True)
    project_id = models.IntegerField()
    staff_id = models.IntegerField()
    status = models.CharField(max_length=100)
    requested_date = models.DateField()
    remarks = models.CharField(max_length=200)

    class Meta:
        managed = False
        db_table = 'project_guide'


class ProjectMembers(models.Model):
    member_id = models.AutoField(primary_key=True)
    student_id = models.IntegerField()
    fk_group_id = models.IntegerField()

    class Meta:
        managed = False
        db_table = 'project_members'


class ProjectReport(models.Model):
    report_id = models.AutoField(primary_key=True)
    report_title = models.CharField(max_length=200)
    file_name = models.CharField(max_length=200)
    fk_project_id = models.IntegerField()
    mark = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'project_report'


class ProjectTimeline(models.Model):
    timeline_id = models.AutoField(primary_key=True)
    batch_id = models.IntegerField()
    module = models.CharField(max_length=200)
    deadline = models.DateField()

    class Meta:
        managed = False
        db_table = 'project_timeline'


class Staff(models.Model):
    staff_id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=200)
    address = models.CharField(max_length=200)
    phone = models.CharField(max_length=200)
    email = models.CharField(max_length=200)
    gender = models.CharField(max_length=200)
    status = models.CharField(max_length=200)

    class Meta:
        managed = False
        db_table = 'staff'


class StaffTechnologies(models.Model):
    s_tech_id = models.AutoField(primary_key=True)
    tech_id = models.IntegerField()
    staff_id = models.IntegerField()

    class Meta:
        managed = False
        db_table = 'staff_technologies'


class Student(models.Model):
    student_id = models.AutoField(primary_key=True)
    student_name = models.CharField(max_length=200)
    register_no = models.CharField(max_length=200)
    admission_no = models.CharField(max_length=200)
    gender = models.CharField(max_length=200)
    phone_no = models.CharField(max_length=200)
    address = models.CharField(max_length=200)
    email = models.CharField(max_length=200)
    batch_id = models.CharField(max_length=200)

    class Meta:
        managed = False
        db_table = 'student'


class Task(models.Model):
    task_id = models.AutoField(primary_key=True)
    task_name = models.TextField()
    fk_project_id = models.IntegerField()
    task_status = models.CharField(max_length=50)

    class Meta:
        managed = False
        db_table = 'task'


class Technologies(models.Model):
    tech_id = models.AutoField(primary_key=True)
    tech_name = models.CharField(max_length=200)

    class Meta:
        managed = False
        db_table = 'technologies'
