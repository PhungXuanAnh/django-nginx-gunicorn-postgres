from django.db import models
from ckeditor_uploader.fields import RichTextUploadingField
class Question(models.Model):
    question_content = RichTextUploadingField(default='content of question')
    question_text = models.CharField(max_length=200, verbose_name="Question")
    pub_date = models.DateTimeField('date published')

    def __str__(self):
        return self.question_text
        
class Choice(models.Model):
    choice_detail = RichTextUploadingField(default='choice detail')
    question = models.ForeignKey(Question, on_delete=models.CASCADE)
    choice_text = models.CharField(max_length=200)
    votes = models.IntegerField(default=0)

    def __str__(self):
        return self.choice_text