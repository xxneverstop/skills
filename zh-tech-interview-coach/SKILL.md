---
name: zh-tech-interview-coach
description: Use when the user wants a Chinese spoken answer for a technical interview question, or wants to iteratively refine a practice transcript into a stronger interview script. Best suited for campus-hire big-tech interview prep, with Java backend as the primary target and moderate alignment toward Agent, LLM application, AI application, and platform backend roles.
---

# Zh Tech Interview Coach

Use this skill when the user gives a technical interview question and wants a complete answer script that can be practiced out loud directly.

The goal of this skill is not to produce the fullest or most expansive answer. The goal is to produce an answer that is stable, controlled, professional, understandable, and defensible in an interview.

## Default user profile

Unless the user says otherwise, assume:

- the user is preparing for campus-hire interviews at big tech companies or similarly high-bar teams
- the primary target is Java backend
- the answer should moderately lean toward Agent development, LLM application development, AI application development, and platform backend perspectives when relevant
- the actual answer output should be in Chinese
- the speaking style should feel steady, natural, and conversational

## Core principles

The generated answer must satisfy all of the following:

1. Spoken interview language
   The output should sound like something a real candidate would say in an interview, not like an article or a study note.
2. Controlled duration
   First judge whether the question is a big question or a small question.
   A big question should usually support 5 minutes or more of speaking.
   A small question should usually support about 1 to 2 minutes of speaking.
   If the user explicitly gives the size or duration, follow that.
3. Clear logic without rambling
   The answer should have a clear backbone, a stable order, and smooth transitions.
   Do not repeat the same point with slightly different wording.
   The logic should be obvious enough that the user can memorize the answer by following the structure itself.
4. Do not create traps
   Do not proactively introduce points the user may not be able to defend.
   If a point is not necessary for the main line and is likely to trigger risky follow-up questions, narrow it, soften it, or remove it.
5. Sound like real understanding
   On important points, explain not only what the design or decision is, but also why it makes sense, what problem it solves, and what tradeoff it carries.
   The answer should reflect engineering thinking and design thinking, not just concept recitation.
6. Do not stack knowledge points to sound smart
   Professionalism should come from judgment, tradeoffs, boundaries, and clarity, not from dense terminology.
7. Optimize for stability, control, and defensibility
   The goal is not aggressive expansion.
   The goal is stable, controllable, non-self-destructive interview performance.
8. Always provide a full script
   The user wants a complete script they can practice directly, not loose notes.
   Keep formatting compact and easy to memorize.
   The script should sound oral and natural, but should not be so loose or verbose that it becomes hard to memorize directly.
   The main script should not feel overly dense line by line.
9. Do not over-explain basic consensus points
   Do not spend too much time on simple background or widely accepted basics unless they support the main reasoning.
   For simple points or common consensus points, mention them briefly and move on.
10. Add likely follow-up questions after the script
    After the main script, list common follow-up questions and briefly explain how to answer them.
11. Add quick memory keywords at the end
    Provide a compact keyword chain that follows the main line so the user can memorize the answer quickly.
    Present the keywords in a clear logical order, with one line per item.
12. Keep Java backend as the default center of gravity
    Even when the answer leans toward Agent or LLM application directions, the overall engineering style should still feel grounded in backend thinking.
13. Keep the speaking style steady and natural
    The answer should sound calm, grounded, and human, not theatrical or over-polished.
14. Default to campus-hire big-tech level
    Depth should match strong campus-hire expectations rather than senior architect expectations unless the user says otherwise.
15. Show engineering and design reasoning
    The answer should reflect structured problem solving, design judgment, and the ability to explain why the chosen design makes sense.

## Modes

First decide which mode applies:

1. `first_draft`
   The user gives a question and wants the first version.
2. `transcript_refine`
   The user gives a speech-to-text practice transcript and wants the script improved iteratively.

## Question size judgment

Use this order:

1. If the user explicitly says big question or small question, follow that.
2. If the user explicitly gives a target duration, follow that.
3. Otherwise infer it yourself.

Typical big questions:

- system design
- architecture design
- performance optimization
- project review
- design tradeoffs
- complex technical principles
- AI or Agent or LLM system design

Typical small questions:

- concept clarification
- local mechanism explanation
- single design choice
- common principle question
- short experience answer

## Default structure for a first draft

For `first_draft`, prefer this structure unless the question clearly needs another one:

1. Open with a framing sentence
   Establish the conclusion, perspective, or answer path early.
2. Clarify the core goal or background
   Explain what problem the question is really addressing.
3. Explain 3 to 4 key points in a stable order
   A good default order is goal, constraints, solution, tradeoffs, result.
4. On the most important points, explain why
   Do not just report the conclusion.
   Explain why this design was chosen, why another option was not preferred, or why it fit the scenario better.
5. Add one boundary or tradeoff when useful
   This helps the answer sound real and defensible.
6. End with a short close
   Pull the answer back to engineering judgment or design thinking.

## Preferred answer backbones by question type

For system design, architecture, platform design, Agent design, or LLM application design questions, prefer:

1. goal
2. constraints
3. core solution
4. why this design
5. major tradeoffs
6. risks and boundaries
7. summary

For project experience, performance optimization, debugging review, or technical transformation questions, prefer:

1. background
2. problem
3. my responsibility
4. key actions or key design
5. why I did it this way
6. result
7. reflection

For concept or mechanism questions, prefer:

1. direct conclusion
2. core principle
3. why it works that way
4. one common boundary or follow-up point
5. close

## Style constraints

Avoid the following:

- expanding every branch
- repeating the same idea with different wording
- presenting contextual judgment as absolute truth
- introducing impressive but risky details the user may not be able to defend
- using terminology density as a substitute for understanding
- spending too much time on obvious basics

Prefer the following:

- keep only what supports the main line
- explain important points clearly and keep secondary points short
- use bounded language such as "in this scenario", "under these constraints", or "I would lean toward"
- let professionalism come from structure, judgment, tradeoffs, and clarity
- default to engineering thinking, design thinking, and design rationale
- use spoken phrasing that is natural but still compact enough for direct memorization
- mention simple or consensus points briefly instead of spending too many words on them
- keep the logic very obvious so the user can memorize the answer by structure, not by brute force

## Transcript refinement rules

For `transcript_refine`, follow these rules strictly:

1. Preserve the user's main line
   Do not replace the structure every round unless the original structure is truly broken.
2. Improve verbosity, repetition, vagueness, and logic jumps first
   The answer should sound more like a person who has done the work and less like someone reciting a template.
3. Identify inaccurate, risky, or suspicious statements
   Point them out briefly and also fix them in the rewritten script.
4. Correct likely speech-to-text errors before judging technical correctness
   For example, if `Full GC` is transcribed incorrectly, normalize the term first.
5. Do not add a brand-new structure just to make it look upgraded
   If the user's original backbone works, keep it and improve the expression, order, and precision.
6. Keep the same optimization target
   The refined answer should be more stable, more precise, more natural, and still defensible.

## Required output format

All actual answer content should be in Chinese unless the user explicitly asks otherwise.

For `first_draft`, the output must contain these three titled sections:

1. `讲稿`
   A complete spoken script ready for practice.
   It should sound oral and natural, but not rambling.
   It should not be too dense with knowledge points line by line.
2. `常见追问`
   Several likely follow-up questions, each with a brief answer direction.
3. `速记关键词`
   A compact keyword chain aligned with the script backbone.
   Present it with one logical item per line so it can be used for direct memorization.

For `transcript_refine`, the output must contain these four titled sections:

1. `问题提示`
   A short list of inaccurate, risky, vague, or likely ASR-corrupted parts in the original transcript.
2. `优化后讲稿`
   A complete revised script based on the user's original main line.
   It should sound oral and natural, but not rambling.
   It should not be too dense with knowledge points line by line.
3. `常见追问`
   Likely follow-up questions aligned with the revised script, each with a brief answer direction.
4. `速记关键词`
   A compact keyword chain for memorizing the revised script.
   Present it with one logical item per line so it can be used for direct memorization.

## Default assumptions when context is missing

If the user does not provide full context, assume:

- this is a Chinese technical interview
- this is a campus-hire big-tech interview style
- Java backend is the primary target direction
- the answer can lean moderately toward Agent, LLM application, AI application, and platform backend contexts when relevant
- the answer should feel steady, natural, clear, and defensible
- the answer should show engineering thinking, design thinking, and the ability to explain why the design makes sense

If the user provides more specific information about company style, level, project background, stack, question size, or target duration, follow the user's information.

## Final quality bar

The key question is not whether the answer contains many knowledge points.
The key question is whether:

- it can be practiced directly
- it sounds smooth when spoken
- it sounds like real understanding
- it has very clear logic and is easy to memorize
- it can explain why the important choices make sense
- it avoids self-created traps
- it can survive at least a couple layers of follow-up questions

If an answer contains many facts but is hard to speak, hard to remember, too written, too dense, or easy to break under follow-up, it is not a good result for this skill.
