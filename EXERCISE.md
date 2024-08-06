# Exercise types in Utter stories

These are the exercise types that will be used in the Utter stories automatically. These exercises may exist for all levels of difficulty but the specific difficulty of each question will be set using a tag (A1/A2/B1/B2/C1). If multiple fit then they are concatenated with a "-" (eg. A1-A2 or A2-B1).

We refer to singular exercises and units of story as exercise blocks and story blocks, respectively.

## Comprehension

Note that I did not specify whether it is listening or reading comprehension since the learner is able to toggle between having audio or not. There are subcategories to this.

### Multiple choice question

- type: comp-mcq
- action: display the question and the three answer options
- description: an exercise to check the understanding of a word or event occuring in the previous story block
- evaluation: correct choice selection
- skip-condition: none
- prompt:

### True-false question

- type: comp-tf
- action: display the question and the true/false answer options
- description: an exercise to check the understanding of an event occuring in the previous story block
- evaluation: correct choice selection
- skip-condition: none
- prompt:

### Listening comprehension multiple choice

- type: comp-listen
- action: hide the last text of the previous story block and provide three alternative answers that look similar
- evaluation: correct choice selection
- description: an exercise to check the oral comprehension of a spoken section of the previous block
- skip-condition: when audio is toggled off
- prompt:

## Pronunciation

In these exercises the learner needs to practice closed-form speaking, meaning that they do not need to come up with words themselves but rather repeat a provided text with their audio being evaluated, just like Duolingos pronunciation exercises.

### Repetition

- type: pronounce-rep
- action: visually specify the piece of text to be repeated and provide a button to press to start speaking
- evaluation: some live pronunciation evaluator
- description: an exercise to check the pronunciation of the user after hearing the text spoken just before
- skip-condition: when voice is toggled off
- prompt:

### Deaf

- type: pronounce-deaf
- action: turn off audio in the final section of the story block for the user to pronounce it on behalf of the character then display a button to start speaking
- evaluation: some live pronunciation evaluator
- description: an exercise to check the pronunciation of the user before hearing it
- skip-condition: when voice is toggled off
- prompt:

## Open Speak/Text

### Replace character

- type: speak-replace
- action: present a character bubble with no text and ask user to speak on their behalf, also show a hint. Their response is processed and guardrailed (then spoken by character)
- evaluation: something has to be said/written but they get more points if they use more words that make sense, pronunciation is evaluated in parallel too
- description: an exercise to practice the ability to think of and speak words in the language in the context of the story
- skip-condition: if voice is disabled, they can text their response instead
- prompt:

### Question

- type: speak-question
- action: display a question that is open-ended and a speak button for a single utterance by the user, also show a hint
- evaluation: something has to be said/written but they get more points if they use more words that make sense, pronunciation is evaluated in parallel too
- description: an exercise to practice the ability to think of and speak words in the language in response to a question directed at them, but related to the story
- skip-condition: if voice is disabled, they can text their response instead
- prompt:

## Live interaction

- type: interact
- action: display a full-screen popup with a question that is open-ended and a start conversation button for an interaction (text interface if voice disabled), also show hints
- evaluation: something has to be said/written but they get more points if they use more words that make sense, pronunciation is evaluated in parallel too
- description: the interaction can be stopped by a button press by the user once 3-4 utterances are made or a minute has passed
- skip-condition: if voice is disabled, they can text instead
- prompt:
