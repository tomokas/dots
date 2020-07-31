import os
import re
import six
import sys
import time
import json
import errno
import random
import urllib
import pprint
import decimal
import logging
import datetime
import importlib
import functools
import itertools
import subprocess
import collections

try:
    import urllib2
except ImportError:
    pass

utcnow = datetime.datetime.utcnow

try:
    import numpy
except ImportError:
    pass

def ago(**kwargs):
    return utcnow() - datetime.timedelta(**kwargs)

def future(**kwargs):
    return utcnow() + datetime.timedelta(**kwargs)

def GET(url):
    import urllib
    return urllib.urlopen(url).read()

if 'DJANGO_SETTINGS_MODULE' in os.environ:
    from django.db import models, transaction, connection, connections
    from django.conf import settings
    from django.http import HttpRequest
    from django.db.models import Q
    from django.core.mail import send_mail
    from django.core.files import File
    from django.core.cache import cache
    from django.contrib.auth import get_user_model
    from django.core.files.base import ContentFile
    from django.core.files.storage import default_storage
    from django.contrib.auth.models import Group
    from django.contrib.staticfiles.storage import staticfiles_storage

    try:
        from django.urls import reverse, resolve
    except ImportError:
        from django.core.urlresolvers import reverse, resolve

    User = get_user_model()

    def u(val):
        if not isinstance(val, six.string_types):
            return User.objects.get(pk=val)

        if '@' in val:
            return User.objects.get(email=val)

        if 'username' in [x.attname for x in User._meta.fields]:
            return User.objects.get(username=val)

        raise User.DoesNotExist()

    try:
        from django.utils.lru_cache import lru_cache
        u = lru_cache()(u)
    except ImportError:
        from django.utils.functional import memoize
        u = memoize(u, {}, 1)

    def DGET(url):
        import urllib
        from django.core.files.base import ContentFile
        return ContentFile(urllib.urlopen(url).read())

    try:
        from django.apps import apps
        get_models = apps.get_models
    except ImportError:
        get_models = models.get_models

    for model in get_models():
        globals()['%s_%s' % (model._meta.app_label, model._meta.object_name)] = model
        del model

    cursor = connection.cursor()

    # Hunt for "me"
    for x in (
        'tom@thread.com',
    ):
        try:
            user = u(x)
        except User.DoesNotExist:
            continue

        locals()['tom'] = user

        request = HttpRequest()
        request.user = user
        break

    superusers = User.objects.filter(is_superuser=True)

    User.__unicode__ = lambda self: u"%s (pk=%d, username='%s', email='%s')" % (
        self.get_full_name() or '(unknown)',
        self.pk,
        getattr(self, 'username', '(unknown)'),
        self.email,
    )

    # Avoid having to print or otherwise str() a Query
    models.sql.query.Query.__repr__ = lambda self: str(self)

    def pw(val=None, password='q', user=locals().get('user', None)):
        if val is not None:
            user = u(val)

        print("I: Set password for {} to '{}'".format(
            user,
            password,
        ))
        user.set_password(password)
        user.save()

        try:
            user.totpdevice_set.all().delete()
            print("I: Removed TOTP devices for {}".format(user))
        except Exception:
            pass

ip = "You are already in IPython"
