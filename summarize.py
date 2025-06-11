from transformers import pipeline
import re

pipe = pipeline("summarization", model="sshleifer/distilbart-cnn-12-6", framework="pt")

def clean_and_trim_log(log_path, max_length=1024):
    with open(log_path, "r") as file:
        content = file.read()

    # Remove ANSI escape sequences (e.g. \x1b[0m or \033[1m)
    ansi_escape = re.compile(r'\x1B(?:[@-Z\\-_]|\[[0-?]*[ -/]*[@-~])')
    cleaned = ansi_escape.sub('', content)

    cleaned_lines = [line.strip() for line in cleaned.splitlines()]
    cleaned_text = "\n".join(cleaned_lines)

    print(cleaned_text[:max_length])
    return cleaned_text[:max_length]

path_to_log = "tf-apply-log.txt"
text = clean_and_trim_log(path_to_log)

summary = pipe(text)[0]['summary_text']
print('---------------------------------------------------')
print("Summary:", summary)


with open("summary.txt", "w") as f:
    f.write("TERRAFORM LOG SUMMARY\n")
    f.write("="*60 + "\n")
    f.write(summary)
    f.write("\n" + "="*60)