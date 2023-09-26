import { PartialType } from '@nestjs/mapped-types';
import { CreateQuestRequirementDto } from './create-quest-requirement.dto';

export class UpdateQuestRequirementDto extends PartialType(CreateQuestRequirementDto) {}
