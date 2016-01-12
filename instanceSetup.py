#######################################################
# This is convenience code for working with ambition instances
######################################################

# set up to work with django
import sys
import django
sys.path.extend(['.', '..', '../..'])
django.setup()

# do imports
import datetime
import re

from dateutil.parser import parse
import pandas as pd
from django.db.models import Min, Max

from animal.models import MetricConfig, TimeGroupConfig, Metric, DailyAvgConfig
from entity.models import Entity, EntityKind, EntityRelationship
from ambition_score.models import ScoreConfig, ParamConfig
from animal import Animal
from lucy import Lucy
from lucy import frame_maker as fm


# define class for getting info from an instance
class InstanceInfo(object):
    def _slugify(self, name):
        return str(re.sub(re.compile(r'\s'), '_', name.lower().strip()))

    @property
    def org_entity(self):
        return Entity.objects.get(entity_kind__name='organization')

    @property
    def role_entities(self):
        return Entity.objects.filter(entity_kind__name='collection.Role')

    @property
    def role_slug_map(self):
        return {self._slugify(e.display_name): e for e in self.role_entities}

    @property
    def role_slug_list(self):
        return sorted([self._slugify(e.display_name) for e in self.role_entities])

    @property
    def metric_configs(self):
        return MetricConfig.objects.filter(is_active=True)

    @property
    def metric_config_names(self):
        return sorted([m.name for m in self.metric_configs])

    @property
    def metric_config_display_names(self):
        return sorted([m.display_name for m in self.metric_configs])

    @property
    def metric_config_alt_names(self):
        return sorted([self._slugify(s) for s in self.metric_config_display_names])

    @property
    def counts_by_role(self):
        out = []
        for e in self.role_entities:
            out.append((self._slugify(e.display_name), Entity.objects.is_sub_to_all(e).count()))
        return pd.DataFrame(out, columns=['role', 'number']).sort_index(by=['number', 'role'], ascending=[False, True])
        return {
            self._slugify(e.display_name): Entity.objects.is_sub_to_all(e).count()
            for e in self.role_entities
        }

    @property
    def account_entities_by_role_slug(self):
        out = []
        for role in self.role_entities:
            for account in Entity.objects.is_sub_to_all(role).filter(entity_kind__name='account'):
                out.append({'role': self._slugify(role.display_name), 'account': account})
        return pd.DataFrame(out).sort_index(by=['role', 'account'])[['role', 'account']]


    @property
    def earliest_metric_time(self):
        return Metric.objects.filter(metric_config__is_active=True).aggregate(Min('time'))['time__min']

    @property
    def latest_metric_time(self):
        return Metric.objects.filter(metric_config__is_active=True).aggregate(Max('time'))['time__max']

