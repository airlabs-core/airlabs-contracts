import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
} from '@nestjs/common';
import { QuestRequirementService } from './quest-requirement.service';
import { CreateQuestRequirementDto } from './dto/create-quest-requirement.dto';
import { UpdateQuestRequirementDto } from './dto/update-quest-requirement.dto';

@Controller('quest-requirement')
export class QuestRequirementController {
  constructor(
    private readonly questRequirementService: QuestRequirementService,
  ) {}

  @Post()
  create(@Body() createQuestRequirementDto: CreateQuestRequirementDto) {
    return this.questRequirementService.create(createQuestRequirementDto);
  }

  @Get()
  findAll() {
    return this.questRequirementService.findAll();
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.questRequirementService.findOne(+id);
  }

  @Patch(':id')
  update(
    @Param('id') id: string,
    @Body() updateQuestRequirementDto: UpdateQuestRequirementDto,
  ) {
    return this.questRequirementService.update(+id, updateQuestRequirementDto);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.questRequirementService.remove(+id);
  }
}
