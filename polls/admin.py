from django.contrib import admin
from django.urls import path

from .models import Choice, Question

@admin.register(Choice)
class ChoiceAdmin(admin.ModelAdmin):
        # remove add permission
    def has_add_permission(self, request):
        return False  
    
    # remove delete permision
    def has_delete_permission(self, request, obj=None):
        return False  

@admin.register(Question)
class QuestionAdmin(admin.ModelAdmin):
        # remove add permission
    def has_add_permission(self, request):
        return False  
    
    # remove delete permision
    def has_delete_permission(self, request, obj=None):
        return False  
