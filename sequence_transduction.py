# !pip install transformers

from transformers import MarianMTModel,MarianTokenizer

model_name = 'Helsinki-NLP/opus-mt-en-hi'
tokenizer = MarianTokenizer.from_pretrained(model_name)
model = MarianMTModel.from_pretrained(model_name)

input = input("Enter the english sentence you want to translate:");
input_tokens = tokenizer(input,return_tensors='pt') #return input tokens as pytorch tensors: requirement for MariaMTModel
trans_tokens = model.generate(**input_tokens)
result = tokenizer.batch_decode(trans_tokens, skip_special_tokens=True)[0]

print("The hindi sentence is:",result)
