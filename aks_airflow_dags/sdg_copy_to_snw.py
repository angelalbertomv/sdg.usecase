#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
import os

from airflow import DAG
from airflow.providers.cncf.kubernetes.operators.kubernetes_pod import KubernetesPodOperator
from airflow.utils.dates import days_ago

args = {
    'owner': 'airflow',
}

with DAG(
    dag_id='sdg_test_case_dwhpropagation_v01',
    default_args=args,
    schedule_interval=None,
    start_date=days_ago(2),
    tags=['SDG', 'USECASE'],
) as dag:

    task = KubernetesPodOperator(
        task_id='dwh_propagation',
        name='dwh_propagation',        
        namespace='airflow',
        image='ghcr.io/angelalbertomv/sdg.usecase/sdgusecasedag1:v3',
    )