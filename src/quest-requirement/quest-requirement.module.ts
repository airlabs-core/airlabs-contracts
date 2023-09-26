import { Module } from '@nestjs/common';
import { QuestRequirementService } from './quest-requirement.service';
import { QuestRequirementController } from './quest-requirement.controller';

@Module({
  controllers: [QuestRequirementController],
  providers: [QuestRequirementService],
})
export class QuestRequirementModule {}
