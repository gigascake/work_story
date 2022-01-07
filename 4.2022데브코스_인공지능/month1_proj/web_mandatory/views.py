from django.shortcuts import render, HttpResponse

# Create your views here.
def index(request):
    return render(request, "index.html")

def about(request):
    return render(request, "About.html")

def topic_one(request):
    return render(request, "week4-3.EDA_1data_analysis.html")

def topic_two(request):
    return render(request, "week4-3.EDA_2Hypothesis.html")

def topic_3th(request):
    return render(request, "week4-3.EDA_3Hypothesis validation.html")