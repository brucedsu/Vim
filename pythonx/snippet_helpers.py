import os

# Example source names and class names:
# cat.c -> Cat
# animal_manager.cpp -> AnimalManager
def get_class_name(source):
    source_name = str(source)

    # filename contains file extension: cat.cpp
    filename = os.path.basename(source_name)

    # basename is filename without file type extension: cat
    basename = os.path.splitext(filename)[0]

    words = basename.split('_')
    capilized_words = map(str.capitalize, words)
    return ''.join(capilized_words)
