App này bắt khởi đầu từ poll app sample

- [Cài đặt các yêu cầu](#cài-đặt-các-yêu-cầu)
    - [Yêu cầu chung](#yêu-cầu-chung)
    - [Yêu cầu sử dụng widget với file upload](#yêu-cầu-sử-dụng-widget-với-file-upload)
- [Cách sử dụng](#cách-sử-dụng)
    - [Thêm vào model field](#thêm-vào-model-field)
    - [Thêm vào widget](#thêm-vào-widget)
- [Cấu hình ckeditor](#cấu-hình-ckeditor)
- [Cách sử dụng ckeditor để tạo 1 bài viết](#cách-sử-dụng-ckeditor-để-tạo-1-bài-viết)

# Cài đặt các yêu cầu

## Yêu cầu chung

1. Cài đặt môi trường 

```shell
pip install django-ckeditor
```

2. Thêm **ckeditor** vào **INSTALLED_APP** settings

3. Chạy lệnh `python manage.py collectstatic --noinput`

Lệnh này sẽ copy các file static của CKEditor vào thư mục định nghĩa bởi **STATIC_ROOT** trong setting

4. Cấu hình **CKEDITOR_BASEPATH** Xem trong [README.md](https://github.com/PhungXuanAnh/django-ckeditor) của **django-ckeditor**

## Yêu cầu sử dụng widget với file upload

1. Thêm **ckeditor_uploader** vào **INSTALLED_APPS** 

2. Thêm **CKEDITOR_UPLOAD_PATH** vào settings. Cài đặt này chỉ định đường dẫn tương đối đến thư mục upload của CKEditor. CKEditor sử dụng API storage của Django. Mặc định, Django sử dụng các thiết lập lưu trữ file backend (nó sẽ sử dụng **MEDIA_ROOT** và **MEDIA_URL**), nếu không sử dụng backend khác, thì bạn phải có quyền ghi cho đường dẫn **CKEDITOR_UPLOAD_PATH** trong **MEDIA_ROOT**.

Thêm vào settings

```python
MEDIA_ROOT = os.path.join(BASE_DIR,'MEDIA')
CKEDITOR_UPLOAD_PATH = 'uploads/ckeditor/'
```

Với thiết lập trên, image sẽ được upload vào thư mục **MEDIA_ROOT/CKEDITOR_UPLOAD_PATH/yyyy/MM/dd** nghĩa là **MEDIA/uploads/ckeditor/yyyy/MM/dd** bên trong project

Khi sử dụng lưu trữ file mặc định, ảnh sẽ được upload đến thư mục "upload" trong **MEDIA_ROOT** và **URL** sẽ được tạo ra dựa vào **MEDIA_URL** 

Để server có thể phục vụ file media, thêm vào **settings.py** và **urls.py** của project

```python
# settings.py
MEDIA_URL = '/media/'
```

```python
# urls.py
from django.conf import settings
from django.conf.urls.static import static
if settings.DEBUG:
    # static files (images, css, javascript, etc.)
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
```

Thiết lập trong file **urls.py** ở trên có nghĩa là phục vụ các file media/static bên trong thư mục **MEDIA_ROOT** với đường link mô tả bởi **MEDIA_URL**, như vậy image sẽ được phục vụ với url **MEDIA_URL/MEDIA_ROOT/../image.jpg** nghĩa là **/media/uploads/ckeditor/yyyy/MM/dd/image.jpg**

Nếu muốn điều khiển việc tự sinh ra tên file, tạo một module sinh tên file và thêm vào settings:

```python
# utils.py

def get_filename(filename):
    return filename.upper()
```

```python
# settings.py

CKEDITOR_FILENAME_GENERATOR = 'utils.get_filename'
```

3. Với cấu hình lưu trữ file hệ thống mặc định, **MEDIA_ROOT** and **MEDIA_URL** phải được thiết lập đúng để các file media làm việc 

4. Thêm CKEditor URL include vào urls.py file của project:

```python
url(r'^ckeditor/', include('ckeditor_uploader.urls')),
```

5. Chú ý rằng khi thêm Url trên nghĩa là thêm các view upload và browser cho việc upload image

6. Thiết lập **CKEDITOR_IMAGE_BACKEND** với config được hỗ trợ bởi backend để cho phép hiện thị hình ảnh nhỏ trong ckeditor gallery. Mặc định không có hình nhỏ nào được tạo ra và ảnh full size được sử dụng để preview. Được hỗ trợ bởi backend là:

    pillow: Uses Pillow

cài đặt: `pip install pillow`

thêm vào setting
```python
CKEDITOR_IMAGE_BACKEND = "pillow"
```


# Cách sử dụng

## Thêm vào model field

Cách nhanh nhất để thêm vào model là sử dụng kiểu model **RichTextField**  trong **ckeditor.fields** hoặc thêm mục upload file thì sử dụng **RichTextUploadingField** trong **ckeditor_uploader.fields**. Thêm vào file **model.py**


```python
from ckeditor.fields import RichTextField

class Question(models.Model):
    question_content = RichTextField(config_name='Question Content', default='content of question')
    #...

class Choice(models.Model):
    choice_detail = RichTextField(config_name='Choice Detail', default='choice detail')
    #...
```

hoặc với upload file 

```python
from ckeditor_uploader.fields import RichTextUploadingField

class Question(models.Model):
    question_content = RichTextUploadingField(config_name='Question Content', default='content of question')
    #...

class Choice(models.Model):
    choice_detail = RichTextUploadingField(config_name='Choice Detail', default='choice detail')
    #...
```

Chạy lệnh: 

```shell 
python manage.py makemigrations polls
python manage.py migrate
python manage.py runserver
```
Truy cập
http://127.0.0.1:8001/admin/polls/question/1/change/
hoặc
http://127.0.0.1:8001/admin/polls/choice/1/change/
để xem kết quả

## Thêm vào widget 

tham khảo link: https://github.com/PhungXuanAnh/django-ckeditor#widget


# Cấu hình ckeditor

Thêm cấu hình sau vào settings

```python
CKEDITOR_CONFIGS = {
    'default': {
        'skin': 'moono',
        # 'skin': 'office2013',
        'toolbar_Basic': [
            ['Source', '-', 'Bold', 'Italic']
        ],
        'toolbar_YourCustomToolbarConfig': [
            {'name': 'document', 'items': ['Source', '-', 'Save', 'NewPage', 'Preview', 'Print', '-', 'Templates']},
            {'name': 'clipboard', 'items': ['Cut', 'Copy', 'Paste', 'PasteText', 'PasteFromWord', '-', 'Undo', 'Redo']},
            {'name': 'editing', 'items': ['Find', 'Replace', '-', 'SelectAll']},
            {'name': 'forms',
             'items': ['Form', 'Checkbox', 'Radio', 'TextField', 'Textarea', 'Select', 'Button', 'ImageButton',
                       'HiddenField']},
            '/',
            {'name': 'basicstyles',
             'items': ['Bold', 'Italic', 'Underline', 'Strike', 'Subscript', 'Superscript', '-', 'RemoveFormat']},
            {'name': 'paragraph',
             'items': ['NumberedList', 'BulletedList', '-', 'Outdent', 'Indent', '-', 'Blockquote', 'CreateDiv', '-',
                       'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock', '-', 'BidiLtr', 'BidiRtl',
                       'Language']},
            {'name': 'links', 'items': ['Link', 'Unlink', 'Anchor']},
            {'name': 'insert',
             'items': ['Image', 'Flash', 'Table', 'HorizontalRule', 'Smiley', 'SpecialChar', 'PageBreak', 'Iframe']},
            '/',
            {'name': 'styles', 'items': ['Styles', 'Format', 'Font', 'FontSize']},
            {'name': 'colors', 'items': ['TextColor', 'BGColor']},
            {'name': 'tools', 'items': ['Maximize', 'ShowBlocks']},
            {'name': 'about', 'items': ['About']},
            '/',  # put this to force next toolbar on new line
            {'name': 'yourcustomtools', 'items': [
                # put the name of your editor.ui.addButton here
                'Preview',
                'Maximize',

            ]},
        ],
        'toolbar': 'YourCustomToolbarConfig',  # put selected toolbar config here
        # 'toolbarGroups': [{ 'name': 'document', 'groups': [ 'mode', 'document', 'doctools' ] }],
        # 'height': 291,
        # 'width': '100%',
        # 'filebrowserWindowHeight': 725,
        # 'filebrowserWindowWidth': 940,
        # 'toolbarCanCollapse': True,
        # 'mathJaxLib': '//cdn.mathjax.org/mathjax/2.2-latest/MathJax.js?config=TeX-AMS_HTML',
        'tabSpaces': 4,
        'extraPlugins': ','.join([
            'uploadimage', # the upload image feature
            # your extra plugins here
            'div',
            'autolink',
            'autoembed',
            'embedsemantic',
            'autogrow',
            # 'devtools',
            'widget',
            'lineutils',
            'clipboard',
            'dialog',
            'dialogui',
            'elementspath'
        ]),
    }
}
```

hoặc

```python
CKEDITOR_CONFIGS = {
    'default': {
        'toolbar': None,
    },
    'myToolbar': {
        'toolbar': 'Advanced',
        'width': 500,
        'height': 250,
    },
}
```

# Cách sử dụng ckeditor để tạo 1 bài viết

Xem đoạn text tạo sẵn để biết các tool hay dùng tại link này:
http://127.0.0.1:8001/admin/polls/choice/1/change/


Thao khảo: [CKEditor 3.x User's Guide](https://docs-old.ckeditor.com/CKEditor_3.x/Users_Guide)

hoặc [CKEditor 3.x User's Guide backup](docs-old.ckeditor.com/CKEditor_3.x/Users_Guide.html)
hoặc search với keywork: **CKEditor 3.x User's Guide**
