import re
import os

filepath = r"c:\Users\ТЕХНОРАЙ\Desktop\Бот недвижка россия\src\components\LeadCard.tsx"

with open(filepath, 'r', encoding='utf-8') as f:
    content = f.read()

# Remove useI18n import
content = re.sub(r'import \{ useI18n \} from "@/i18n";\n', '', content)

# Remove t, locale destructing
content = re.sub(r'\s+const \{ t, locale \} = useI18n\(\);\n', '\n', content)

# Remove translation state
content = re.sub(r'\s+const \[translatedData, setTranslatedData\] = useState<any>\(null\);\n\s+const \[isTranslating, setIsTranslating\] = useState\(false\);\n', '\n', content)

# Remove auto-translation useEffect - it's a big block
start_effect = content.find('// Handle auto-translation of AI lead data')
end_effect = content.find('// Determine language flag')
if start_effect != -1 and end_effect != -1:
    content = content[:start_effect] + content[end_effect:]

# Replace stage config
content = content.replace('t("leads.stages.sandbox")', '"Песочница"')
content = content.replace('t("leads.stages.warmup")', '"Прогрев"')
content = content.replace('t("leads.stages.handoff")', '"Готов"')
content = content.replace('t("leads.stages.reactivation")', '"Реактивация"')

# Replace time string
content = content.replace('t("common.time.min")', '"мин"')
content = content.replace('t("common.time.hour")', '"ч"')
content = content.replace('t("common.time.day")', '"д"')
content = content.replace('t("common.time.ago")', '"назад"')

# Replacing t('...')
replacements = {
    't("leads.card.anonymous")': '"Анонимный клиент"',
    't("leads.card.lang")': '"Язык"',
    "t('leads.card.inWorkActive')": '"В работе ✓"',
    "t('leads.card.interest')": '"ИНТЕРЕС"',
    "t('leads.card.budget')": '"БЮДЖЕТ"',
    "t('leads.card.noBudget')": '"Не определен"',
    "t('leads.card.urgency')": '"СРОКИ"',
    "t('leads.card.purpose')": '"ЦЕЛЬ"',
    "t('leads.card.unitType')": '"ТИП"',
    "t('leads.card.area')": '"РАЙОН"',
    "t('leads.card.mainInterest')": '"ГЛАВНЫЙ ИНТЕРЕС"',
    't("leads.card.unit")': '"Объект"',
    't("leads.card.addressToVerify")': '"Адрес уточняется"',
    "t('leads.card.managerHints')": '"ПОДСКАЗКИ МЕНЕДЖЕРУ"',
    "t('leads.card.dialogue')": '"ОПИСАНИЕ ДИАЛОГА"',
    "t('leads.card.sold')": '"Продано"',
    "t('leads.card.release')": '"Снять с работы"',
    "t('leads.card.inWork')": '"В работу"',
    "t('leads.card.delete')": '"Удалить"',
    "t('leads.card.confirm')": '"Точно?"',
    "t('leads.card.snooze')": '"24ч"',
    "t('leads.card.details')": '"Подробнее"',
    "t('leads.card.notSet')": '"Не указано"',
}

for k, v in replacements.items():
    content = content.replace(k, v)

# Replace translatedData fallbacks
content = re.sub(r'translatedData\?\.([a-zA-Z_]+) \|\| lead\.data(?:\?\.|\.)\1', r'lead.data?.\1', content)
content = re.sub(r'translatedData\?\.([a-zA-Z_]+) \|\| lead\.data\1', r'lead.data?.\1', content) # To be sure

# Handle specific array translations in TSX
content = content.replace('translatedData?.interested_units && translatedData.interested_units.length > 0\n                            ? translatedData.interested_units.join(\', \')\n                            : (lead.data?.interested_units && lead.data.interested_units.length > 0)\n                                ? lead.data.interested_units.join(\', \')\n                                : (translatedData?.interest || lead.data?.interest || "Не указано")',
                          '(lead.data?.interested_units && lead.data.interested_units.length > 0)\n                                ? lead.data.interested_units.join(\', \')\n                                : (lead.data?.interest || "Не указано")')

content = content.replace('translatedData?.preferred_areas || (lead.data?.preferred_areas && lead.data.preferred_areas.length > 0)', '(lead.data?.preferred_areas && lead.data.preferred_areas.length > 0)')
content = content.replace('translatedData?.preferred_areas || lead.data.preferred_areas.join(\', \')', 'lead.data.preferred_areas.join(\', \')')

# Remove isTranslating conditional classes
content = content.replace('${isTranslating ? \'opacity-50\' : \'\'}', '')

with open(filepath, 'w', encoding='utf-8') as f:
    f.write(content)

print('Success')
