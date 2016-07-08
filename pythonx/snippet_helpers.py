import os

# Example source names and class names:
# cat.c -> cat
# animal_manager.cpp -> animal_manager
def get_cpp_class_name(source):
    class_name = str(source).lower()

    # remove unnecessary path
    # e.g. abc/cba/cat.cpp -> cat.cpp
    class_name = os.path.basename(class_name)

    # remove extension
    # e.g. cat.cpp -> cat
    class_name = os.path.splitext(class_name)[0]

    # if there exists underscore,
    # remove underscores and capitalize each component
    # e.g. pretty_cat.cpp -> PrettyCat
    # if class_name.count('_'):
    #     words = class_name.split('_')
    #     capilized_words = map(str.capitalize, words)
    #     class_name = ''.join(capilized_words)

    # if there exists colon, it is an inheritance in cpp
    if class_name.count(':'):
        class_name = class_name.split(':')[0]

    return class_name

def get_underscore_separated_class_name(source):
    return ""

def get_camel_case_class_name(source):
    return ""
