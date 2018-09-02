
# coding: utf-8

# ## Leitura das imagens

# In[1]:


from pyspark.ml.image import ImageSchema
from pyspark.sql.functions import lit

IMG_DIR = "chest_xray/"

train_df_normal = ImageSchema.readImages(IMG_DIR + "/train/NORMAL").withColumn("label", lit(0))
train_df_pneumonia = ImageSchema.readImages(IMG_DIR + "/train/PNEUMONIA").withColumn("label", lit(1))
train_df = train_df_normal.union(train_df_pneumonia)

test_df_normal = ImageSchema.readImages(IMG_DIR + "/test/NORMAL").withColumn("label", lit(0))
test_df_pneumonia = ImageSchema.readImages(IMG_DIR + "/test/PNEUMONIA").withColumn("label", lit(1))
test_df = test_df_normal.union(test_df_pneumonia)


# ## Treino do modelo

# In[ ]:


from sparkdl import DeepImageFeaturizer
from pyspark.ml import Pipeline
from pyspark.ml.classification import LogisticRegression

featurizer = DeepImageFeaturizer(inputCol="image", outputCol="features", modelName="InceptionV3")
lr = LogisticRegression(maxIter=20, regParam=0.05, elasticNetParam=0.3, labelCol="label")
pipeline = Pipeline(stages=[featurizer, lr])
model = pipeline.fit(train_df)


# ## Exibição do resultado por imagem

# In[ ]:


from pyspark.ml.evaluation import MulticlassClassificationEvaluator

prediction = model.transform(test_df)
data_selection = prediction.select(prediction.image.origin, 'prediction')

data_selection.show(truncate=False)


# ## Exibição da Acurácia

# In[ ]:


prediction = model.transform(test_df)

prediction_and_labels = prediction.select('prediction', 'label')
evaluator = MulticlassClassificationEvaluator(metricName='accuracy')

print('Acurácia', str(evaluator.evaluate(prediction_and_labels)))

