from django.contrib import admin
# # Register your models here.
from .models import Choice, Question


# Method 0
# admin.site.register(Question)

# Method 1: Reorder the fields
# class QuestionAdmin(admin.ModelAdmin):
#     fields = ['pub_date', 'question_text']

# admin.site.register(Question, QuestionAdmin)

# Method 2: Group the fields
# class QuestionAdmin(admin.ModelAdmin):
#     fieldsets = [
#         (None,               {'fields': ['question_text']}),
#         ('Date information', {'fields': ['pub_date']}),
#     ]

# admin.site.register(Question, QuestionAdmin)
# admin.site.register(Choice)

# Method 3: add choices inline
class ChoiceInline(admin.TabularInline):
    model = Choice
    extra = 3


class QuestionAdmin(admin.ModelAdmin):
    fieldsets = [
        (None,               {'fields': ['question_text']}),
        ('Date information', {'fields': ['pub_date'], 'classes': ['collapse']}),
    ]
    inlines = [ChoiceInline]
    list_filter = ['pub_date'] # add a filter
    search_fields = ['question_text'] # add a serch bar

    list_display = ('question_text',
    'pub_date',
    'was_published_recently') # display indexes in tabular view


admin.site.register(Question, QuestionAdmin)